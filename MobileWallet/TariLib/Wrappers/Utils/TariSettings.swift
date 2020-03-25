//  TariSettings.swift

/*
	Package MobileWallet
	Created by Jason van den Berg on 2020/03/14
	Using Swift 5.0
	Running on macOS 10.15

	Copyright 2019 The Tari Project

	Redistribution and use in source and binary forms, with or
	without modification, are permitted provided that the
	following conditions are met:

	1. Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above
	copyright notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	3. Neither the name of the copyright holder nor the names of
	its contributors may be used to endorse or promote products
	derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
	CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
	OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
	NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
	OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation

enum TariNetworks: String {
    case mainnet = "mainnet"
    case rincewind = "rincewind"
}

struct TariSettings {
    static let shared = TariSettings()

    let network: TariNetworks = .rincewind //TODO this will come from a build config
    let deeplinkURI = "tari"

    //For UI changes it can be a bit slow to keep waiting for tor to bootstrap.
    //Set to false if you're just working on the UI.
    #if targetEnvironment(simulator)
    let torEnabled = true
    #else
    let torEnabled = true
    #endif

    #if DEBUG
    //Used for showing a little extra detail in the UI to help debugging
    let isDebug = true
    //Local macbook node
    let defaultBasenodePeer = "10092c2299efcb5b8ec27ab847b5ec645d79536cf8cf40c7b8757fa141151864::/onion3/kgk5tclng6v2ohbufp3nhhes7f4camb5ukkxyudoph6hzj5ip65dv4yd:9050"
    let maxMbLogsStorage: UInt64 = 5000 //5GB
    #else
    let isDebug = false
    //Taribot faucet node
    let defaultBasenodePeer = "2e93c460df49d8cfbbf7a06dd9004c25a84f92584f7d0ac5e30bd8e0beee9a43::/onion3/nuuq3e2olck22rudimovhmrdwkmjncxvwdgbvfxhz6myzcnx2j4rssyd:18141"
    let maxMbLogsStorage: UInt64 = 500 //500MB
    #endif
}
