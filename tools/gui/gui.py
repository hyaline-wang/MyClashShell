#!/usr/bin/python3

from traceback import format_exc
import sys, os, time, re, curses
import locale
locale.setlocale(locale.LC_ALL, '')
os.environ.setdefault('ESCDELAY', '250')
os.environ["NCURSES_NO_UTF8_ACS"] = "1"

move_dirs = {curses.KEY_DOWN : (1, 0), curses.KEY_UP : (-1, 0), curses.KEY_RIGHT : (0, 1), curses.KEY_LEFT : (0, -1),
                ord('s') : (1, 0), ord('w') : (-1, 0), ord('d') : (0, 1), ord('a') : (0, -1)}

colors = {'white': curses.COLOR_WHITE, 'red': curses.COLOR_RED, 'green': curses.COLOR_GREEN,
            'yellow': curses.COLOR_YELLOW, 'blue': curses.COLOR_BLUE, 'magenta': curses.COLOR_MAGENTA,
            'cyan': curses.COLOR_CYAN, 'black': curses.COLOR_BLACK}

class SuspendCurses():
    def __enter__(self):
        curses.endwin()
    def __exit__(self, exc_type, exc_val, tb):
        newscr = curses.initscr()
        newscr.refresh()
        curses.doupdate()

def cp(i):
    return curses.color_pair(i)

def set_pairs(fg, bg):
    curses.init_pair(1, fg, colors['black'])
    curses.init_pair(2, fg, colors['yellow'])
    curses.init_pair(3, fg, colors['white'])
    curses.init_pair(4, fg, colors['red'])
    curses.init_pair(5, colors['black'], bg)
    curses.init_pair(6, colors['yellow'], bg)
    curses.init_pair(7, colors['white'], bg)
    curses.init_pair(8, colors['red'], bg)
    curses.init_pair(9, colors['white'], colors['green'])
    curses.init_pair(10, colors['white'], colors['red'])


def ping_google():
    import requests
    proxies = {
      "http":"http://127.0.0.1:7890",
      "https":"https://127.0.0.1:7890"}
    url="https://www.google.com"
    try:
        _ret = requests.get(url, proxies=proxies,timeout=1)
    except Exception as e:
        print(e)
        return False
    return True



def main_loop(stdscr):
    ret = 0
    EXIT = False
    check_connect = ping_google()

    try:
        curses.curs_set(1) #set curses options and variables
        curses.noecho()
        curses.cbreak()
        maxc = curses.COLORS
        maxy, maxx = stdscr.getmaxyx()
        if maxy < 12 or maxx < 60:
            with SuspendCurses():
                print('Terminal window needs to be at least 12 h by 60 w')
                print('Current h:{0}  and w:{1}'.format(maxy, maxx))
            ret = 1
            EXIT = True
        stdscr.refresh()
        h, w = 12, 65
        test_win = curses.newwin(h, w, 0, 0)
        stdscr.nodelay(1)
        test_win.leaveok(0)
        test_win.keypad(1)
        test_win.bkgd(' ', cp(0))
        test_win.box()
        cursor = [0, 0]
        test_win.move(2, 2+cursor[1]*20)
        fgcol, bgcol = 1, 1
        set_pairs(fgcol, bgcol)
        test_win.refresh()
        cursor_bounds = ((0,2),(0,1)) # x_bound y_bound
        teststr = '! @ # $ % ^ & *     _ + - = '
        k, newk = 1, 2
        while not EXIT:
            if k > -1:
                test_win.clear()
                if k in move_dirs.keys():  #move cursor left or right with wrapping
                    cursor[1] += move_dirs[k][1]
                    if cursor[1] > cursor_bounds[1][1]: cursor[1] = cursor_bounds[1][0]
                    if cursor[1] < cursor_bounds[1][0]: cursor[1] = cursor_bounds[1][1]
                    cursor[0] += move_dirs[k][0]
                    if cursor[0] > cursor_bounds[0][1]: cursor[0] = cursor_bounds[0][0]
                    if cursor[0] < cursor_bounds[0][0]: cursor[0] = cursor_bounds[0][1]
                if k == 45:  #decr currently selected attr
                    if cursor[1] == 0:
                        fgcol -= 1
                        if fgcol < 0: fgcol = maxc-1
                    else:
                        bgcol -= 1
                        if bgcol < 0: bgcol = maxc-1
                    set_pairs(fgcol, bgcol)
                if k == 43:  #incr currently selected attr
                    if cursor[1] == 0:
                        fgcol += 1
                        if fgcol > maxc-1: fgcol = 0
                    else:
                        bgcol += 1
                        if bgcol > maxc-1: bgcol = 0
                    set_pairs(fgcol, bgcol)
                if k in (ord('q'), 27):
                    EXIT = True
                # test_win.addstr(1, 10, '{0} colors supported'.format(maxc), cp(0))
                test_win.addstr(1, 10, 'My Clash Control Panel', cp(0))

                # test_win.addstr(2, 2, 'FG: {0}  '.format(fgcol), cp(0))
                # 0 black_front 1 red_front 2 red_yellow 3 red_white 4 white_red
                # 5 white_red 6 yellow_red 7
                if(check_connect):
                    test_win.addstr(2, 2, 'Ping Google:{0}'.format("success"), cp(9))
                else:
                    test_win.addstr(2, 2, 'Ping Google:{0}'.format("failed"), cp(10))
        

                test_win.addstr(1, 32, '{0}  '.format(cursor), cp(0))


                test_win.addstr(3, 2, 'PROXY MODE: {0}'.format('Global'), cp(0))
                test_win.addstr(3, 32, 'USE_SUBCRIBE: {0}'.format('default'), cp(0))

                # log
                test_win.addstr(4, 2, 'LOG MONITER:', cp(0))

                # for i in range(1,5):
                #     test_win.addstr(3+i, 2, teststr, cp(i))
                #     test_win.addstr(3+i, 32,teststr, cp(i+4))
                test_win.addstr(9, 2, 'use enter to change,use q to exit', cp(0))

                test_win.move(2+cursor[0], 2+cursor[1]*30)
                test_win.box()
                test_win.refresh()
                curses.napms(10)
            newk = stdscr.getch()
            if newk != k:
                k = newk
    except KeyboardInterrupt:
        pass
    except:
        ret = 1
        with SuspendCurses():
            print(format_exc())
    finally:
        return ret

if __name__ == '__main__':
    try:
        _ret = curses.wrapper(main_loop)
    except Exception as e:
        print(e)
    finally:
        check_connect = ping_google()
        # print(check_connect)
        # print('Exit status ' + str(_ret))
        sys.exit(_ret)
