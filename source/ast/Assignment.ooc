/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/Assignment.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Expr, Visitor, Node

/**
 * A binary operation
 */
Assignment: class extends Node {

    left: String
    right: Expr

    init: func (=left, =right) {}

    toString: func -> String {
        "%s = %s" format(left toCString(), right toString() toCString())
    }

    accept: func (v: Visitor) {
        v visitAssignment(this)
    }

}

