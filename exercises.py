#!/bin/python3

# exercises tracker
# go to the #-protected block below to modify tracker progress

# alternative with bash
# https://unix.stackexchange.com/questions/11343/linux-tools-to-treat-files-as-sets-and-perform-set-operations-on-them
# https://catonmat.net/set-operations-in-unix-shell
# https://catonmat.net/set-operations-in-unix-shell-simplified

import sys

print("please source exercises.bashrc instead")
sys.exit(1)

def BE(B,E):
    assert int == type(B)
    assert int == type(E)
    return set(range(B,E+1))

def print2(A):
    if 0 == len(A):
        print("\u2714 100%")
        return
    assert 10 <= len(A) and len(A) <= 99
    for i, a in enumerate(A):
        if i != 0 and i % 7 == 0:
            print()
        print("%2d "%(a,),end='')
    print()

assert 2 == len(sys.argv)
assert str == type(sys.argv[1])

# assert set == type(globals()[sys.argv[1]])
# # print(globals()[sys.argv[1]])
# print2(globals()[sys.argv[1]])

##########################################################
# appendixD = set(range(1,89+1)) - set(range(39,41+1))
trackers = {
    # "appendixD": BE(1,89)
    "appendixD": BE(1,89) - BE(39,39),
    # "appendixD": set(),
    "appendixZ": set(),
}
##########################################################

tk = trackers[sys.argv[1]]
assert set == type(tk)
print2(tk)
