##	**NOTES**	##
/*
	Notes about NixOS Configuration:
	# `xserver.enable = true`  automatically configures the X Server and by default
	uses LightDM as a display manager. Configuring X server from the beggining
	look into sx package (alternative to xinit and startx) and at the [Wiki]
	(https://nixos.wiki/wiki/Using_X_without_a_Display_Manager).
	# `xserver.autorun = true;`service can be disabled and started through tty using
	`systemctl start display-manager.service`.
	# 
	
	Notes about Nix language:
	# `let` is recursive and lazy: `let x = x; in x` gives error about infinite
	recursion; `let x = x; in 5` just evaluates to `5`.
	# `with foo; ...` still keeps `foo` visible inside the `...` code.
	# `{ inherit (foo.bar) baz xyzzy; }` is shortcut for `{ baz = foo.bar.baz;
	xyzzy = foo.bar.xyzzy; }`.
	# `import ./foo/bar.nix arg1 arg2` loads code from ./foo/bar.nix and then
	calls it as a function with arguments `arg1` and `arg2`.
	# `foo.bar or baz` returns `foo.bar` if `foo` has attribute `bar`, or
	expression `baz` otherwise. In other words, `baz` is a "default value" if
	`.bar` is missing.
	# `"foo ${bar.baz}"` evaluates to `bar.baz.outPath` string if present (see also
	builtins.toString and [nix pill 6]
	(http://lethalman.blogspot.com/2014/07/nix-pill-6-our-first-derivation.html)).
	# `foo ? bar` returns true if foo contains attribute bar.
*/
