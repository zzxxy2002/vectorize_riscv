// See LICENSE for license details.

//**************************************************************************
// Vectorized complex multiply
//--------------------------------------------------------------------------

    .text
    .align 2

    .global cmplxmult
    .type cmplxmult,@function
/*
 * void cmplxmult(size_t n, const struct Complex a[], const struct Complex b[], struct Complex c[]);
 *
 * Calling convention:
 *     a0: size_t n
 *     a1: struct Complex *a
 *     a2: struct Complex *b
 *     a3: struct Complex *c
 */
cmplxmult:
    vsetvli t0, a0, e32, m4     # configure SEW=32 LMUL=4
    sub a0, a0, t0
    # TODO: load a[i].real and a[i].imag
    # TODO: load b[i].real and b[i].imag

    vlseg2e32.v v8, (a1)      # v8 = a[i].real, v12 = a[i].imag
    vlseg2e32.v v16, (a2)       # v16 = b[i].real, v20 = b[i].imag


    # TODO: compute c[i].real = (a[i].real * b[i].real) - (a[i].imag * b[i].imag)
    # HINT: 2 instructions needed
    
    vfmul.vv v24, v8, v16        # c[i].real = a[i].real * b[i].real
    vfnmsac.vv v24, v12, v20 # c[i].real = c[i].real - a[i].imag * b[i].imag


    # TODO: compute c[i].imag = (a[i].real * b[i].imag) + (a[i].imag * b[i].real)
    # HINT: 2 instructions needed
    vfmul.vv v28, v8, v20        # c[i].real = a[i].real * b[i].imag
    vfmacc.vv v28, v12, v16 # c[i].real = c[i].real + a[i].imag * b[i].real
    # TODO: store c[i].real and c[i].real
    vsseg2e32.v v24, (a3)

    # TODO: decrement n (a0)
    # TODO: bump pointers
    # TODO: loop


    slli t0, t0, 3

    add a1, a1, t0
    add a2, a2, t0
    add a3, a3, t0

    bnez a0, cmplxmult

    ret
