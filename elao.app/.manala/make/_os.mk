######
# Os #
######

# Os detection helpers.
#
# Examples:
#
# Example #1: conditions on osx
#
#   echo $(if $(OS_DARWIN),Running on OSX,*NOT* running on OSX)

OS_DARWIN = $(findstring $(shell uname -s),Darwin)
OS_LINUX = $(findstring $(shell uname -s),Linux)
