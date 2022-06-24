//  UTXOTileView.swift
	
/*
	Package MobileWallet
	Created by Adrian Truszczynski on 06/06/2022
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
import TariCommon

final class UTXOTileView: UICollectionViewCell {
    
    struct Model: Hashable {
        let uuid: UUID
        let amountText: String
        let backgroundColor: UIColor?
        let height: CGFloat
        let statusIcon: UIImage?
        let statusName: String
    }
    
    // MARK: - Subviews
    
    @View private var backgroundContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    @View private var amountContentView = UIView()
    
    @View private var tickView: UTXOsWalletTileTickView = {
        let view = UTXOsWalletTileTickView()
        view.alpha = 0.0
        return view
    }()
    
    @View private var amountLabel: CurrencyLabelView = {
        let view = CurrencyLabelView()
        view.textColor = .tari.white
        view.font = .Avenir.black.withSize(30.0)
        view.secondaryFont = .Avenir.black.withSize(12.0)
        view.separator = "."
        view.iconHeight = 13.0
        return view
    }()
    
    @View private var statusIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .tari.white
        return view
    }()
    
    @View private var statusLabel: UILabel = {
        let view = UILabel()
        view.textColor = .tari.white
        view.font = .Avenir.medium.withSize(12.0)
        return view
    }()
    
    // MARK: - Properties
    
    private(set) var elementID: UUID?
    
    var isTickSelected: Bool = false {
        didSet { update(selectionState: isTickSelected) }
    }
    
    var isSelectModeEnabled: Bool = false {
        didSet { updateTickBox(isVisible: isSelectModeEnabled) }
    }
    
    var onTapOnTickbox: ((UUID) -> Void)?
    var onLongPress: ((UUID) -> Void)?
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCallbacks()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    func update(model: Model) {
        elementID = model.uuid
        backgroundContentView.backgroundColor = model.backgroundColor
        amountLabel.text = model.amountText
        statusIcon.image = model.statusIcon
        statusLabel.text = model.statusName
    }
    
    private func setupViews() {
        backgroundColor = .tari.white
        layer.cornerRadius = 10.0
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        contentView.addSubview(backgroundContentView)
        amountContentView.addSubview(amountLabel)
        [amountContentView, statusIcon, statusLabel, tickView].forEach(backgroundContentView.addSubview)

        backgroundContentView.isUserInteractionEnabled = false
        [amountContentView, statusIcon, statusLabel].forEach { $0.isUserInteractionEnabled = false }

        let constraints = [
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundContentView.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
            backgroundContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.0),
            backgroundContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.0),
            backgroundContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0),
            tickView.topAnchor.constraint(equalTo: backgroundContentView.topAnchor, constant: 10.0),
            tickView.leadingAnchor.constraint(equalTo: backgroundContentView.leadingAnchor, constant: 10.0),
            tickView.heightAnchor.constraint(equalToConstant: 24.0),
            tickView.widthAnchor.constraint(equalToConstant: 24.0),
            amountContentView.topAnchor.constraint(equalTo: backgroundContentView.topAnchor),
            amountContentView.leadingAnchor.constraint(equalTo: backgroundContentView.leadingAnchor),
            amountContentView.trailingAnchor.constraint(equalTo: backgroundContentView.trailingAnchor),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: amountContentView.leadingAnchor, constant: 10.0),
            amountLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountContentView.trailingAnchor, constant: -10.0),
            amountLabel.centerXAnchor.constraint(equalTo: backgroundContentView.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: backgroundContentView.centerYAnchor),
            statusIcon.leadingAnchor.constraint(equalTo: backgroundContentView.leadingAnchor, constant: 10.0),
            statusIcon.heightAnchor.constraint(equalToConstant: 14.0),
            statusIcon.widthAnchor.constraint(equalToConstant: 14.0),
            statusIcon.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusLabel.topAnchor.constraint(equalTo: amountContentView.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 6.0),
            statusLabel.trailingAnchor.constraint(equalTo: backgroundContentView.trailingAnchor, constant: -10.0),
            statusLabel.bottomAnchor.constraint(equalTo: backgroundContentView.bottomAnchor, constant: -10.0),
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCallbacks() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture))
        [tapGesture, longPressGesture].forEach(addGestureRecognizer)
    }
    
    // MARK: - Actions
    
    private func update(selectionState: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            let shadow: Shadow = selectionState ? .selection : .none
            self.apply(shadow: shadow)
        }
        
        tickView.isSelected = selectionState
    }
    
    private func updateTickBox(isVisible: Bool) {
        
        UIView.animate(withDuration: 0.1) {
            self.tickView.alpha = isVisible ? 1.0 : 0.0
        }
    }
    
    // MARK: - Target Actions
    
    @objc private func onTapGesture() {
        guard let elementID = elementID else { return }
        onTapOnTickbox?(elementID)
    }
    
    @objc private func onLongPressGesture() {
        guard let elementID = elementID else { return }
        onLongPress?(elementID)
    }
}
