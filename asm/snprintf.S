//  ibex - printf shim: GNU AArch64 ABI -> Apple ARM64 ABI (max 5 args)
//
//  Copyright (c) 2017 xerub
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


#define fp x29
#define lr x30

	.global	__snprintf
__snprintf:
	stp	fp, lr, [sp, #-16]!
	mov	fp, sp

	stp	x7, x0, [sp, #-16]!
	stp	x5, x6, [sp, #-16]!
	stp	x3, x4, [sp, #-16]!
	stp	x1, x2, [sp, #-16]!

	bl	_get_snprintf_addr
	mov	x3, x0
	ldr	x0, [sp, #56]
	ldp	x1, x2, [sp], #16
	blr	x3

	ldp	x3, x4, [sp], #16
	ldp	x5, x6, [sp], #16
	ldp	x7, x8, [sp], #16

	ldp	fp, lr, [sp], #16
	ret
