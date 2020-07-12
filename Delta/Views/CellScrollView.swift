//
//  CellScrollView.swift
//  Delta
//
//  Created by Nathan FALLET on 12/07/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class CellScrollView: UIScrollView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesBegan(touches, with: event)
        } else {
            self.superview?.touchesBegan(touches, with: event)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)    {
        if self.isDragging {
            super.touchesCancelled(touches, with: event)
        } else {
            self.superview?.touchesCancelled(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesEnded(touches, with: event)
        } else {
            self.superview?.touchesEnded(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging {
            super.touchesMoved(touches, with: event)
        } else {
            self.superview?.touchesMoved(touches, with: event)
        }
    }
    
}
