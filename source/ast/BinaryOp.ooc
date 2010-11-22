/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/BinaryOp.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Expr, Visitor

/**
 * A binary operation
 */
BinaryOp: class extends Expr {

    type: String
    left, right: Expr

    init: func (=type, =left, =right) {}

    toString: func -> String {
        "%s %s %s" format(left toString() toCString(), type toCString(), right toString() toCString())
    }

    accept: func (v: Visitor) {
        v visitBinaryOp(this)
    }

}

