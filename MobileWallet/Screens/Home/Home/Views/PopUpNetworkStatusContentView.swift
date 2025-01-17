//  PopUpNetworkStatusContentView.swift
	
/*
	Package MobileWallet
	Created by Adrian Truszczynski on 15/07/2022
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

final class PopUpNetworkStatusContentView: UIView {
    
    // MARK: - Subviews
    
    @View private var topRowStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 36.0
        return view
    }()
    
    @View private var bottomRowStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 36.0
        return view
    }()
    
    @View private var columnStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 20.0
        return view
    }()
    
    @View private var networkStatusView: StatusView = {
        let view = StatusView()
        view.update(icon: Theme.shared.images.connectionInternetIcon)
        return view
    }()
    
    @View private var torStatusView: StatusView = {
        let view = StatusView()
        view.update(icon: Theme.shared.images.connectionTorIcon)
        return view
    }()
    
    @View private var baseNodeConnectionStatusView: StatusView = {
        let view = StatusView()
        view.update(icon: Theme.shared.images.settingsBaseNodeIcon)
        return view
    }()
    
    @View private var baseNodeSyncStatusView: StatusView = {
        let view = StatusView()
        view.update(icon: Theme.shared.images.connectionSyncIcon)
        return view
    }()
    
    // MARK: - Initialisers
    
    init() {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupConstraints() {
        
        addSubview(columnStackView)
        [topRowStackView, bottomRowStackView].forEach(columnStackView.addArrangedSubview)
        [networkStatusView, torStatusView].forEach(topRowStackView.addArrangedSubview)
        [baseNodeConnectionStatusView, baseNodeSyncStatusView].forEach(bottomRowStackView.addArrangedSubview)
        
        let constraints = [
            columnStackView.topAnchor.constraint(equalTo: topAnchor),
            columnStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            columnStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            columnStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            columnStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Updates
    
    func updateNetworkStatus(text: String, statusColor: UIColor?) {
        networkStatusView.update(text: text, statusColor: statusColor)
    }
    
    func updateTorStatus(text: String, statusColor: UIColor?) {
        torStatusView.update(text: text, statusColor: statusColor)
    }
    
    func updateBaseNodeConnectionStatus(text: String, statusColor: UIColor?) {
        baseNodeConnectionStatusView.update(text: text, statusColor: statusColor)
    }
    
    func updateBaseNodeSyncStatus(text: String, statusColor: UIColor?) {
        baseNodeSyncStatusView.update(text: text, statusColor: statusColor)
    }
}

private class StatusView: UIView {
    
    // MARK: - Subviews
    
    @View private var iconViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .tari.white
        view.apply(shadow: .box)
        view.layer.cornerRadius = 24.0
        return view
    }()
    
    @View private var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .tari.greys.black
        return view
    }()
    
    @View private var statusDotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7.0
        return view
    }()
    
    @View private var label: UILabel = {
        let view = UILabel()
        view.font = .Avenir.medium.withSize(14.0)
        view.textColor = .tari.greys.grey
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    // MARK: - Initialisers
    
    init() {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupConstraints() {
        
        [iconViewBackgroundView, statusDotView, label].forEach(addSubview)
        iconViewBackgroundView.addSubview(iconView)
        
        let constraints = [
            iconViewBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            iconViewBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconViewBackgroundView.widthAnchor.constraint(equalToConstant: 46.0),
            iconViewBackgroundView.heightAnchor.constraint(equalToConstant: 46.0),
            iconView.topAnchor.constraint(equalTo: iconViewBackgroundView.topAnchor, constant: 11.0),
            iconView.leadingAnchor.constraint(equalTo: iconViewBackgroundView.leadingAnchor, constant: 11.0),
            iconView.trailingAnchor.constraint(equalTo: iconViewBackgroundView.trailingAnchor, constant: -11.0),
            iconView.bottomAnchor.constraint(equalTo: iconViewBackgroundView.bottomAnchor, constant: -11.0),
            label.topAnchor.constraint(equalTo: iconViewBackgroundView.bottomAnchor, constant: 5.0),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            statusDotView.topAnchor.constraint(equalTo: iconViewBackgroundView.topAnchor),
            statusDotView.trailingAnchor.constraint(equalTo: iconViewBackgroundView.trailingAnchor),
            statusDotView.widthAnchor.constraint(equalToConstant: 14.0),
            statusDotView.heightAnchor.constraint(equalToConstant: 14.0),
            widthAnchor.constraint(equalToConstant: 110.0),
            heightAnchor.constraint(equalToConstant: 94.0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Updates
    
    func update(text: String, statusColor: UIColor?) {
        label.text = text
        statusDotView.backgroundColor = statusColor
    }
    
    func update(icon: UIImage?) {
        iconView.image = icon
    }
}
