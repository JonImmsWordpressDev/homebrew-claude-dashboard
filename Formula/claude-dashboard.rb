class ClaudeDashboard < Formula
  desc "Claude Mission Control: local dashboard for Claude Code sessions"
  homepage "https://github.com/JonImmsWordpressDev/claude-dashboard"
  url "https://github.com/JonImmsWordpressDev/claude-dashboard/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "9489bd1eae790d7e60aae24bdbab36a1aa2764519ac9a6a8638679b33165b588"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    # Config outside the Cellar so upgrades keep names/ignores/settings.
    (bin/"claude-dashboard").write <<~EOS
      #!/bin/bash
      export CLAUDE_DASH_CONFIG_DIR="${CLAUDE_DASH_CONFIG_DIR:-$HOME/.config/claude-dashboard}"
      if [ "$1" = "statusline" ]; then
        exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/claude-dashboard.js" "$@"
      fi
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/server.js" "$@"
    EOS
  end

  service do
    run [opt_bin/"claude-dashboard"]
    keep_alive true
    log_path var/"log/claude-dashboard.log"
    error_log_path var/"log/claude-dashboard.log"
  end

  test do
    port = free_port
    pid = spawn({ "CLAUDE_DASH_PORT" => port.to_s }, bin/"claude-dashboard")
    sleep 5
    assert_match "ok", shell_output("curl -s http://127.0.0.1:#{port}/api/health")
    assert_match "Opus", pipe_output("#{bin}/claude-dashboard statusline", '{"model":{"display_name":"Opus"}}')
  ensure
    Process.kill("TERM", pid)
  end
end
