class ClaudeDashboard < Formula
  desc "Local dashboard for Claude Code: live sessions, transcripts, costs"
  homepage "https://github.com/JonImmsWordpressDev/claude-dashboard"
  url "https://github.com/JonImmsWordpressDev/claude-dashboard/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6193c2785e27de0359ac74b1f97d44ebc8de247b9a9337c7b3678514ca016156"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    # Config outside the Cellar so upgrades keep names/ignores/settings.
    (bin/"claude-dashboard").write <<~EOS
      #!/bin/bash
      export CLAUDE_DASH_CONFIG_DIR="${CLAUDE_DASH_CONFIG_DIR:-$HOME/.config/claude-dashboard}"
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
  ensure
    Process.kill("TERM", pid)
  end
end
