// See LICENSE for license details.

//**************************************************************************
// Vectorized index of maximum
//--------------------------------------------------------------------------

    .text
    .align 2

    .global imax
    .type imax,@function
/*
 * size_t imax(size_t n, const float x[]);
 *
 * Calling convention:
 *     a0: size_t n
 *     a1: const float *x
 * Return value:
 *     a0: index
 */
imax:
1:  auipc t0, %pcrel_hi(input_inf)
    flw ft0, %pcrel_lo(1b)(t0)  # initialize maximum to -infinity
    vsetvli zero, zero, e32, m8 # preconfigure vector state
    vfmv.s.f v24, ft0           # move -infinity to scalar in v24;
                                # may be useful for reductions
    li t1, 0                    # initialize index
    mv t2, a0                   # save n for index calculations
    li t3, 0                    # initialize loop counter

imax_loop:
    vsetvli t0, a0, e32, m8     # configure SEW=32 LMUL=8

    # TODO: load x[k] vector
    # TODO: find maximum value in vector
    # TODO: compare against global maximum
    vle32.v v0, (a1)            # load vector

    vfredmax.vs v0, v0, v24     # find max in vector
    vfmv.f.s ft1, v0            # move max to scalar
    flt.s t4, ft0, ft1          # compare max to global max
    beqz t4, not_max            # if max is not greater than global max, skip
    
    # TODO: locate position of maximum element; compute new index
    # TODO: update index as necessary
    # TODO: update maximum as necessary
    mv t5, t3
    add a6, t3, t0
    mv t6, a1
start:
    beq a6, t5, not_max
    flw ft1, (t6)
    addi t6, t6, 4
    addi t5, t5, 1
    flt.s t4, ft0, ft1
    beqz t4, start
    
    fmv.s ft0, ft1
    addi t5, t5, -1
    mv t1, t5
    addi t5, t5, 1

    j start

not_max:
    sub a0, a0, t0              # decrement n
    add t3, t3, t0              # increment loop counter
    slli t0, t0, 2              # scale VL to byte offset
    add a1, a1, t0              # bump pointer x
    
    bnez a0, imax_loop          # loop
    
    # TODO: set return value
    mv a0, t1

    ret

    .section .rodata
input_inf:
    .float -inf
