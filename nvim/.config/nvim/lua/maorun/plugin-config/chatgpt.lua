package.loaded["chatgpt.api"] = nil
package.loaded["chatgpt.flows.chat.base"] = nil
package.loaded["chatgpt.flows.chat"] = nil
package.loaded["chatgpt.module"] = nil
package.loaded["chatgpt.settings"] = nil
package.loaded["chatgpt.config"] = nil
package.loaded["chatgpt"] = nil
require("chatgpt").setup({
    api_host_cmd = "echo -n http://0.0.0.0:8000",
    api_key_cmd = 'noting',
    openai_params = {
        stream = false,
    }
})
