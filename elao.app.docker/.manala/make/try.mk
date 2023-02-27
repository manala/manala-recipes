#######
# Try #
#######

# Execute first command (try), unconditionnaly run second command (finally), and
# exit with first command return code.
#
# @param $1 First command
# @param $2 Second command
#
# Examples:
#
# Example #1: Run tests and remove artefacts
#
#   $(call manala_try_finally, phpunit, rm -Rf artefacts)

define manala_try_finally
( \
	$(strip $(1)) \
) ; RC=$${?} \
; $(strip $(2)) \
&& exit $${RC}
endef
