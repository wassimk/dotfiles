return {
  on_attach = function(client)
    -- conflicts with syntax tree inlay hints
    client.server_capabilities.inlayHintProvider = false
  end,
}
