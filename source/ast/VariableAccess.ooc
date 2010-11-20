/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/VariableAccess.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Expr, Visitor

/**
 * Represents access to a variable
 */
VariableAccess: class extends Expr {

    name: String

    init: func (=name) {}

    toString: func -> String {
        name
    }

    accept: func (v: Visitor) {
        v visitVariableAccess(this)
    }

}

