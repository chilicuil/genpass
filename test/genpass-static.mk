all: essential return-codes error-messages pw-generation cache-key config-file interactive-gen

essential:
	test -f genpass
	test -f genpass-static

return-codes:
	printf "%s" '-h' | ./genpass-static -f ./key -C1 -c1 -n1 -p1 1; test X"$${?}" = X"0"
	test -f ./key && rm key
	./genpass-static -n; test X"$${?}"              = X"1"
	./genpass-static -p; test X"$${?}"              = X"1"
	./genpass-static -s; test X"$${?}"              = X"1"
	./genpass-static -f; test X"$${?}"              = X"1"
	./genpass-static -l; test X"$${?}"              = X"1"
	./genpass-static -C; test X"$${?}"              = X"1"
	./genpass-static -c; test X"$${?}"              = X"1"
	./genpass-static --scrypt-r; test X"$${?}"      = X"1"
	./genpass-static --scrypt-p; test X"$${?}"      = X"1"
	./genpass-static --config; test X"$${?}"        = X"1"
	./genpass-static --cui; test X"$${?}"           = X"1"

error-messages:
	test X"$$(./genpass-static -h |head -1)"        = X"Usage: genpass [option]... [site]"
	test X"$$(./genpass-static --help |head -1)"    = X"Usage: genpass [option]... [site]"
	test X"$$(./genpass-static --cui 2>&1|head -1)" = X"genpass: unrecognized option '--cui'"
	test X"$$(./genpass-static --cui     |head -1)" = X""
	test X"$$(./genpass-static -n 2>&1|head -1)"    = X"genpass: option '-n' requires an argument"
	test X"$$(./genpass-static -n     |head -1)"    = X""
	test X"$$(./genpass-static -l a 2>&1|head -1)"  = X"genpass: option '-l' requires a numerical argument, 'a'"
	test X"$$(./genpass-static -la 2>&1|head -1)"   = X"genpass: option '-l' requires a numerical argument, 'a'"
	test X"$$(./genpass-static -la |head -1)"       = X""
	test X"$$(./genpass-static -l1 2>&1|head -1)"   = X"genpass: option '-l' numerical value must be between 8-1024, '1'"
	test X"$$(./genpass-static -C a 2>&1|head -1)"  = X"genpass: option '-C' requires a numerical argument, 'a'"
	test X"$$(./genpass-static -C121 2>&1|head -1)" = X"genpass: option '-C' numerical value must be between 1-30, '121'"
	test X"$$(./genpass-static -c a 2>&1|head -1)"  = X"genpass: option '-c' requires a numerical argument, 'a'"
	test X"$$(./genpass-static -c121 2>&1|head -1)" = X"genpass: option '-c' numerical value must be between 1-30, '121'"
	test X"$$(./genpass-static -e d 2>&1|head -1)"  = X"genpass: invalid text encoding 'd'"
	test X"$$(./genpass-static --config 2>&1|head -1)"          = X"genpass: option '--config' requires an argument"
	test X"$$(./genpass-static --config cui 2>&1|head -1)"      = X"genpass: couldn't load config file 'cui'"
	test X"$$(./genpass-static --scrypt-r 2>&1|head -1)"        = X"genpass: option '--scrypt-r' requires an argument"
	test X"$$(./genpass-static --scrypt-r a 2>&1|head -1)"      = X"genpass: option '--scrypt-r' requires a numerical argument, 'a'"
	test X"$$(./genpass-static --scrypt-r 10291 2>&1|head -1)"  = X"genpass: option '--scrypt-r' numerical value must be between 1-9999, '10291'"
	test X"$$(./genpass-static --scrypt-p 2>&1|head -1)"        = X"genpass: option '--scrypt-p' requires an argument"
	test X"$$(./genpass-static --scrypt-p a 2>&1|head -1)"      = X"genpass: option '--scrypt-p' requires a numerical argument, 'a'"
	test X"$$(./genpass-static --scrypt-r 102911 2>&1|head -1)" = X"genpass: option '--scrypt-r' numerical value must be between 1-9999, '102911'"

pw-generation:
	test X"$$(./genpass-static -f ./key -C1 -c1 -n1 -p1 1)"               = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	test X"$$(./genpass-static -f ./key -C1 -c1 -n1 -p1 1 -e z85)"        = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	test X"$$(./genpass-static -f ./key -C1 -c1 -l8 -e dec -n1 -p1 1)"    = X"57175901779215943103"
	test X"$$(./genpass-static -f ./key -C1 -c1 -l8 -e hex -n1 -p1 1)"    = X"39af5ab15c9f2b67"
	test X"$$(./genpass-static -f ./key -C1 -c1 -l8 -e base64 -n1 -p1 1)" = X"Oa9asVyfK2c"
	test X"$$(./genpass-static -f ./key -C1 -c1 -l8 -e skey -n1 -p1 1)"   = X"RYE EGAN LEAR MEAL USES LUCK"
	test -f ./key && rm key
	test X"$$(./genpass-static -f ./key -C1 -c1 -n2 -p1 1)"                = X"4Topkr=o[<![BSgd)n^<s7PH0+3*U1QUv??*b9hjp"
	test -f ./key && rm key

cache-key:
	./genpass-static -f ./key -v -C1 -c1 -n1 -p1 1     2>&1 | grep "Generating new cache key" >/dev/null 2>&1
	./genpass-static -f ./key -v -C1 -c1 -n1 -p1 1     2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C1 -c1 -l8 -n1 -p1 1 2>&1 | grep "Invalid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C1 -c1 -l8 -n1 -p1 1 2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C1 -c2 -l8 -n1 -p1 1 2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 -n1 -p1 1 2>&1 | grep "Invalid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 -n1 -p1 1 2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 --scrypt-r 1 --scrypt-p 1 -n1 -p1 1 2>&1 | grep "Invalid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 --scrypt-r 1 --scrypt-p 1 -n1 -p1 1 2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 --scrypt-r 2 --scrypt-p 1 -n1 -p1 1 2>&1 | grep "Invalid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 --scrypt-r 2 --scrypt-p 2 -n1 -p1 1 2>&1 | grep "Invalid cache key value" >/dev/null 2>&1
	./genpass-static -f ./key -v -C2 -c1 -l8 --scrypt-r 2 --scrypt-p 2 -n1 -p1 1 2>&1 | grep "Loaded valid cache key value" >/dev/null 2>&1
	test -f ./key && rm key
	./genpass-static -f ./key -1 -v -c1 -n1 -p1 1 2>&1 | grep "Generating single derived key" >/dev/null 2>&1
	test ! -f ./key
	./genpass-static -f ./key -N -v -C1 -c1 -n1 -p1 1 2>&1 | grep "Generating new cache key" >/dev/null 2>&1
	test ! -f ./key

config-file:
	# printf "%s\\n%s\\n" "[user]" "name='1'" > genpass.config #TODO 03-10-2016 12:39 >> BUG, remove ''/"" from name user
	printf "%s\\n%s\\n" "[user]" "name=1" > genpass.config
	test X"$$(./genpass-static -f ./key --config genpass.config -C1 -c1 -p1 1)" = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	printf "%s\\n%s\\n%s\\n" "[user]" "name=1" "site=1" > genpass.config
	test X"$$(./genpass-static -f ./key --config genpass.config -C1 -c1 -p1)"   = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	printf "%s\\n%s\\n%s\\n%s\\n%s\\n" "[user]" "name=1" "site=1" "[general]" "cache_cost=1" > genpass.config
	test X"$$(./genpass-static -f ./key --config genpass.config -c1 -p1)"       = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	printf "%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n" "[user]" "name=1" "site=1" "[general]" "cache_cost=1" "cost=1" > genpass.config
	test X"$$(./genpass-static -f ./key --config genpass.config -p1)"           = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	printf "%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n%s\\n" "[user]" "name=1" "password=1" "site=1" "[general]" "cache_cost=1" "cost=1" > genpass.config
	test X"$$(./genpass-static -f ./key --config genpass.config)"               = X"4>KGf9&t4Xl?:6V+5jSV1ttxP56oiwW>/XmZ^dr{N"
	test -f genpass.config && rm genpass.config
	test -f ./key && rm key

interactive-gen:
	@for genpass_test_exp in test/genpass*exp.sh; do \
		echo "sh'ing $$genpass_test_exp"; \
		sh "$${genpass_test_exp}" || exit 1; \
	done;