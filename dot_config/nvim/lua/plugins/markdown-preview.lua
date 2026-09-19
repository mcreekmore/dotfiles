-- Live markdown preview in the browser. Needs a build step (vim.pack has no
-- build hook), run via PackChanged; registered before add to catch first install.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		local d = args.data
		if d.spec.name == "markdown-preview.nvim" and (d.kind == "install" or d.kind == "update") then
			-- The plugin lives in pack/*/opt and isn't sourced yet during install;
			-- load it so its autoloaded installer resolves, then run it.
			pcall(vim.cmd.packadd, "markdown-preview.nvim")
			if not pcall(vim.fn["mkdp#util#install"]) then
				vim.notify("markdown-preview: run :call mkdp#util#install() to finish setup", vim.log.levels.WARN)
			end
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
})
