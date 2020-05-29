//  TransactionHistoryContainer.swift

/*
	Package MobileWallet
	Created by S.Shovkoplyas on 23.04.2020
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

import UIKit

class TransactionHistoryContainer: UIViewController {
    private var viewContainer = UIView()
    private var child: UIViewController

    init(child: UIViewController) {
        self.child = child
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .clear
        viewContainer.backgroundColor = .clear
    }
}

extension TransactionHistoryContainer {
    private func setup() {
        setupContainer()
        addChild()
    }

    private func setupContainer() {
        view.addSubview(viewContainer)
        viewContainer.clipsToBounds = false

        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 48).isActive = true
        viewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func addChild() {
        child.willMove(toParent: self)
        addChild(child)
        viewContainer.addSubview(child.view)

        child.view.frame = CGRect(x: 0, y: -48, width: viewContainer.bounds.width, height: viewContainer.bounds.height + 48)
        child.didMove(toParent: self)
    }
}