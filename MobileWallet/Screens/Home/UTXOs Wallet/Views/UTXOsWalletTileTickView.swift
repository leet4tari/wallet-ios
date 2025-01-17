//  UTXOsWalletTileTickButton.swift
	
/*
	Package MobileWallet
	Created by Adrian Truszczynski on 09/06/2022
	Using Swift 5.0
	Running on macOS 12.3

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

import UIKit

final class UTXOsWalletTileTickView: UIView {
    
    // MARK: - Subviews
    
    private var tickMask: UIView = {
        let view = UIImageView()
        view.image = Theme.shared.images.utxoTick?.image(withSize: CGSize(width: 24.0, height: 24.0))?.invertedMask
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - Properties
    
    var isSelected: Bool = false {
        didSet { update(selectionState: isSelected) }
    }
    
    // MARK: - Initialisers
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupView() {
        backgroundColor = .tari.white
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.tari.greys.mediumGrey?.cgColor
        update(selectionState: isSelected)
    }
    
    // MARK: - Actions
    
    private func update(selectionState: Bool) {
        layer.borderWidth = selectionState ? 0.0 : 2.0
        mask = selectionState ? tickMask : nil
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tickMask.frame = bounds
    }
}
