import math, argparse
from pathlib import Path

def two_complement(num, bit_width):
    if num < 0:
        num = (1 << bit_width) + num

    return format(num, f'0{bit_width}b')

def fixed_point_two_complement(num, int_bits, frac_bits):
    total_bits = int_bits + frac_bits
    scaled_num = round(num * (1 << frac_bits))
    if scaled_num < 0:
        scaled_num = (1 << total_bits) + scaled_num

    return format(scaled_num, f'0{total_bits}b')

def sigmoid(x):
    try:
        y = 1 / (1 + math.exp(-x))
    except:
        y = 0 if (x < 0) else 1

    return y

def get_memory_init_file(total_bits, LUT_addr_bits, input_int_bits, weight_int_bits):
    total_int_bits = input_int_bits + weight_int_bits
    total_frac_bits = total_bits - total_int_bits
    input_sigmoid_range = (-2 ** (total_int_bits - 1), 2 ** (total_int_bits - 1) - 2 ** (-total_frac_bits))
    LUT_enteries = 2 ** LUT_addr_bits
    step = (input_sigmoid_range[1] - input_sigmoid_range[0]) / (LUT_enteries - 1)
    x_values = [input_sigmoid_range[0] + step * i for i in range(LUT_enteries)]
    y_values = [sigmoid(x) for x in x_values]
    y_values_binary = [fixed_point_two_complement(y, total_int_bits, total_frac_bits) for y in y_values]

    return y_values_binary

parser = argparse.ArgumentParser(prog='gen_sigmoind_mif', description='Generate Memory Initialization File for Sigmoind Function')
parser.add_argument('total_bits', type=int,help='Total number of bits used for representing the fixed point value')
parser.add_argument('input_int_bits', type=int, help='number of bits used for representing the integer part of the input value')
parser.add_argument('weight_int_bits', type=int, help='number of bits used for representing the integer part of the weight value')
parser.add_argument('LUT_addr_bits', type=int, help='number of bits used for addressing the Look-up table storing the sigmoind values')
parser.add_argument('output_file', help='Path to the output mif file')

if __name__ == '__main__':
    args = parser.parse_args()

    if not Path(args.output_file).exists:
        print(f'Specified output file is invalid!: {args.output_file}')

    y_values = get_memory_init_file(args.total_bits, args.LUT_addr_bits, args.input_int_bits, args.weight_int_bits)
    with open(args.output_file, 'w+') as file:
        string = '\n'.join(y_values)
        file.write(string)