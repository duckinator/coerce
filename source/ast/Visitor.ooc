/*
 * Based on decadence (https://github.com/nddrylliog/decadence/raw/master/step7/source/ast/Visitor.ooc)
 * @author Amos Wenger
 * @author Nick Markwell
 */

import Number, BinaryOp, VariableAccess, Assignment

Visitor: interface {

    visitNumber: func (n: Number)
    visitBinaryOp: func (b: BinaryOp)
    visitAssignment: func (a: Assignment)
    visitVariableAccess: func (v: VariableAccess)

}

