//  PopUpUtxoDetailsContentView.swift
	
/*
	Package MobileWallet
	Created by Adrian Truszczynski on 11/07/2022
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

final class PopUpUtxoDetailsContentView: UIView {
    
    struct Model {
        let amount: String
        let statusColor: UIColor?
        let statusText: String
        let commitment: String
        let blockHeight: String?
        let date: String?
    }
    
    // MARK: - Subviews
    
    @View private var amountLabel: CurrencyLabelView = {
        let view = CurrencyLabelView()
        view.textColor = .tari.greys.black
        view.font = .Avenir.heavy.withSize(26.0)
        view.iconHeight = 13.0
        return view
    }()
    
    @View private var rowsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10.0
        return view
    }()
    
    @View private var statusRow = PopUpUtxoContentRowView()
    @View private var commitmentRow = PopUpUtxoContentRowView()
    @View private var blockHeightRow = PopUpUtxoContentRowView()
    @View private var dateRow = PopUpUtxoContentRowView()
    
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
        
        [amountLabel, rowsStackView].forEach(addSubview)
        [statusRow, commitmentRow, blockHeightRow, dateRow].forEach(rowsStackView.addArrangedSubview)
        
        let constraints = [
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rowsStackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 20.0),
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            rowsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Updates
    
    func update(model: Model) {
        amountLabel.text = model.amount
        statusRow.update(title: localized("utxos_wallet.pop_up.details.label.status"), value: model.statusText, statusColor: model.statusColor)
        commitmentRow.update(title: localized("utxos_wallet.pop_up.details.label.commitment"), value: model.commitment, statusColor: nil)
        blockHeightRow.update(title: localized("utxos_wallet.pop_up.details.label.block_height"), value: model.blockHeight, statusColor: nil)
        dateRow.update(title: localized("utxos_wallet.pop_up.details.label.date"), value: model.date, statusColor: nil)
        
        blockHeightRow.isHidden = model.blockHeight == nil
        dateRow.isHidden = model.date == nil
    }
}

private class PopUpUtxoContentRowView: UIView {
    
    // MARK: - Subviews
    
    @View private var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .tari.greys.black
        view.font = .Avenir.heavy.withSize(12.0)
        return view
    }()
    
    @View private var valueRowStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4.0
        view.alignment = .center
        view.distribution = .fillProportionally
        return view
    }()
    
    @View private var statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    @View private var valueLabel: UILabel = {
        let view = UILabel()
        view.textColor = .tari.greys.mediumDarkGrey
        view.font = .Avenir.medium.withSize(12.0)
        view.numberOfLines = 2
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
        
        [titleLabel, valueRowStackView].forEach(addSubview)
        [statusView, valueLabel].forEach(valueRowStackView.addArrangedSubview)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            valueRowStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            valueRowStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            valueRowStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            valueRowStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            statusView.heightAnchor.constraint(equalToConstant: 10.0),
            statusView.widthAnchor.constraint(equalToConstant: 10.0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Update
    
    func update(title: String?, value: String?, statusColor: UIColor?) {
        titleLabel.text = title
        valueLabel.text = value
        statusView.isHidden = statusColor == nil
        statusView.backgroundColor = statusColor
    }
}
