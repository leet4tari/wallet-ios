//  GradientView.swift
	
/*
	Package MobileWallet
	Created by Adrian Truszczynski on 25/03/2022
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

struct GradientLocationData {
    let color: UIColor
    let location: Double
}

extension Array where Element == GradientLocationData {
    static var standardGradient: Self {
        [
            Element(color: Theme.shared.colors.gradientStartColor!, location: 0.0),
            Element(color: Theme.shared.colors.gradientEndColor!, location: 1.0),
        ]
    }
}

final class GradientView: UIView {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    // MARK: - Subviews
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Properties
    
    var locations: [GradientLocationData] = .standardGradient {
        didSet { updateGradient() }
    }
    
    var orientation: Orientation = .vertical {
        didSet { updateOrientation() }
    }
    
    // MARK: - Initialisers
    
    init() {
        super.init(frame: .zero)
        layer.addSublayer(gradientLayer)
        updateGradient()
        updateOrientation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    private func updateGradient() {
        
        gradientLayer.locations = locations
            .map(\.location)
            .map { NSNumber(value: $0) }
        
        gradientLayer.colors = locations
            .map(\.color.cgColor)
    }
    
    private func updateOrientation() {
        switch orientation {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
