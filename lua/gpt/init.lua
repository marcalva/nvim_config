-- Gp (GPT prompt) lua plugin for Neovim
-- https://github.com/Robitx/gp.nvim/

--------------------------------------------------------------------------------
-- Default config
--------------------------------------------------------------------------------

local config = {
	-- Please start with minimal config possible.
	-- Just openai_api_key if you don't have OPENAI_API_KEY env set up.
	-- Defaults change over time to improve things, options might get deprecated.
	-- It's better to change only things where the default doesn't fit your needs.

	-- required openai api key (string or table with command and arguments)
	-- openai_api_key = { "cat", "path_to/openai_api_key" },
	-- openai_api_key = { "bw", "get", "password", "OPENAI_API_KEY" },
	-- openai_api_key: "sk-...",
	openai_api_key = os.getenv("OPENAI_API_KEY") or "NA-123456789",
	-- api endpoint (you can change this to azure endpoint)
	openai_api_endpoint = "https://api.openai.com/v1/chat/completions",
	-- openai_api_endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
	-- prefix for all commands
	cmd_prefix = "Gp",
	-- optional curl parameters (for proxy, etc.)
	-- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
	curl_params = {},

	-- directory for persisting state dynamically changed by user (like model or persona)
	state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",

	-- default command agents (model + persona)
	-- name, model and system_prompt are mandatory fields
	-- to use agent for chat set chat = true, for command set command = true
	-- to remove some default agent completely set it just with the name like:
	-- agents = {  { name = "ChatGPT4" }, ... },
	agents = {
		{
			name = "ChatGPT4",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "ChatGPT3-5",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-3.5-turbo-1106", temperature = 1.1, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "CodeGPT4",
			chat = false,
			command = true,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
		{
			name = "CodeGPT3-5",
			chat = false,
			command = true,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-3.5-turbo-1106", temperature = 0.8, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
	},

	-- directory for storing chat files
	chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
	-- chat user prompt prefix
	chat_user_prefix = "🗨:",
	-- chat assistant prompt prefix (static string or a table {static, template})
	-- first string has to be static, second string can contain template {{agent}}
	-- just a static string is legacy and the [{{agent}}] element is added automatically
	-- if you really want just a static string, make it a table with one element { "🤖:" }
	chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
	-- chat topic generation prompt
	chat_topic_gen_prompt = "Summarize the topic of our conversation above"
		.. " in two or three words. Respond only with those words.",
	-- chat topic model (string with model name or table with model name and parameters)
	chat_topic_gen_model = "gpt-3.5-turbo-16k",
	-- explicitly confirm deletion of a chat file
	chat_confirm_delete = true,
	-- conceal model parameters in chat
	chat_conceal_model_params = true,
	-- local shortcuts bound to the chat buffer
	-- (be careful to choose something which will work across specified modes)
	chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
	chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
	chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
	chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
	-- default search term when using :GpChatFinder
	chat_finder_pattern = "topic ",
	-- if true, finished ChatResponder won't move the cursor to the end of the buffer
	chat_free_cursor = false,

	-- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
	toggle_target = "vsplit",

	-- styling for chatfinder
	-- border can be "single", "double", "rounded", "solid", "shadow", "none"
	style_chat_finder_border = "single",
	-- margins are number of characters or lines
	style_chat_finder_margin_bottom = 8,
	style_chat_finder_margin_left = 1,
	style_chat_finder_margin_right = 2,
	style_chat_finder_margin_top = 2,
	-- how wide should the preview be, number between 0.0 and 1.0
	style_chat_finder_preview_ratio = 0.5,

	-- styling for popup
	-- border can be "single", "double", "rounded", "solid", "shadow", "none"
	style_popup_border = "single",
	-- margins are number of characters or lines
	style_popup_margin_bottom = 8,
	style_popup_margin_left = 1,
	style_popup_margin_right = 2,
	style_popup_margin_top = 2,
	style_popup_max_width = 160,

	-- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
	-- command prompt prefix for asking user for input (supports {{agent}} template variable)
	command_prompt_prefix_template = "🤖 {{agent}} ~ ",
	-- auto select command response (easier chaining of commands)
	-- if false it also frees up the buffer cursor for further editing elsewhere
	command_auto_select_response = true,

	-- templates
	template_selection = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
	template_rewrite = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should replace the selection above.",
	template_append = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
	template_prepend = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
	template_command = "{{command}}",

	-- image generation settings
	-- image prompt prefix for asking user for input (supports {{agent}} template variable)
	image_prompt_prefix_template = "🖌️ {{agent}} ~ ",
	-- image prompt prefix for asking location to save the image
	image_prompt_save = "🖌️💾 ~ ",
	-- default folder for saving images
	image_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
	-- default image agents (model + settings)
	-- to remove some default agent completely set it just with the name like:
	-- image_agents = {  { name = "DALL-E-3-1024x1792-vivid" }, ... },
	image_agents = {
		{
			name = "DALL-E-3-1024x1024-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1024x1792",
		},
	},

	-- example hook functions (see Extend functionality section in the README)
	hooks = {
		InspectPlugin = function(plugin, params)
			local bufnr = vim.api.nvim_create_buf(false, true)
			local copy = vim.deepcopy(plugin)
			local key = copy.config.openai_api_key
			copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
			local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
			local params_info = string.format("Command params:\n%s", vim.inspect(params))
			local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
			vim.api.nvim_win_set_buf(0, bufnr)
		end,

		-- GpImplement rewrites the provided selection/range based on comments in it
		Implement = function(gp, params)
			local template = "Having following from {{filename}}:\n\n"
				.. "```{{filetype}}\n{{selection}}\n```\n\n"
				.. "Please rewrite this according to the contained instructions."
				.. "\n\nRespond exclusively with the snippet that should replace the selection above."

			local agent = gp.get_command_agent()
			gp.info("Implementing selection with agent: " .. agent.name)

			gp.Prompt(
				params,
				gp.Target.rewrite,
				nil, -- command will run directly without any prompting for user input
				agent.model,
				template,
				agent.system_prompt
			)
		end,

		-- your own functions can go here, see README for more examples like
		-- :GpExplain, :GpUnitTests.., :GpTranslator etc.

		-- -- example of making :%GpChatNew a dedicated command which
		-- -- opens new chat with the entire current buffer as a context
		-- BufferChatNew = function(gp, _)
		-- 	-- call GpChatNew command in range mode on whole buffer
		-- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
		-- end,

		-- -- example of adding command which opens new chat dedicated for translation
		-- Translator = function(gp, params)
		-- 	local agent = gp.get_command_agent()
		-- 	local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
		-- 	gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
		-- end,

		-- -- example of adding command which writes unit tests for the selected code
		-- UnitTests = function(gp, params)
		-- 	local template = "I have the following code from {{filename}}:\n\n"
		-- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
		-- 		.. "Please respond by writing table driven unit tests for the code above."
		-- 	local agent = gp.get_command_agent()
		-- 	gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
		-- end,

		-- -- example of adding command which explains the selected code
		-- Explain = function(gp, params)
		-- 	local template = "I have the following code from {{filename}}:\n\n"
		-- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
		-- 		.. "Please respond by explaining the code above."
		-- 	local agent = gp.get_chat_agent()
		-- 	gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
		-- end,
	},
}

require("gp").setup(config)

local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end

-- Chat commands
vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

-- Prompt commands
vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

vim.keymap.set({"n", "i"}, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
vim.keymap.set({"n", "i"}, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
vim.keymap.set({"n", "i"}, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
vim.keymap.set({"n", "i"}, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
vim.keymap.set({"n", "i"}, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

vim.keymap.set({"n", "i"}, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

vim.keymap.set({"n", "i", "v", "x"}, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
vim.keymap.set({"n", "i", "v", "x"}, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

return config
