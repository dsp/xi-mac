// Copyright 2018 The xi-editor Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Protocol describing the frontend interface with core.
/// Documentation for the protocol can be found here:
/// https://xi-editor.github.io/xi-editor/docs/frontend-protocol.html
protocol XiCore {
    /// Sent by the client immediately after establishing the core connection.
    func clientStarted(configDir: String?, clientExtrasDir: String?)
    /// Asks core to change the theme. If the change succeeds the client will receive a `theme_changed` notification.
    func setTheme(themeName: String)
    /// Changes the state of the tracing config.
    func tracingConfig(enabled: Bool)
}

final class CoreRPC: XiCore {

    private let coreConnection: Connection

    init(coreConnection: Connection) {
        self.coreConnection = coreConnection
    }

    func clientStarted(configDir: String?, clientExtrasDir: String?) {
        let params = ["client_extras_dir": clientExtrasDir,
                      "config_dir": configDir]
        sendRpcAsync("client_started", params: params)
    }

    func setTheme(themeName: String) {
        sendRpcAsync("set_theme", params: ["theme_name": themeName])
    }

    func tracingConfig(enabled: Bool) {
        sendRpcAsync("tracing_config", params: ["enabled": enabled])
    }

    private func sendRpcAsync(_ method: String, params: Any, callback: RpcCallback? = nil) {
        coreConnection.sendRpcAsync(method, params: params, callback: callback)
    }
}