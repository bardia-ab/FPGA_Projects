class Parameter:

    def __init__(self, name, value):
        self.name = name
        self.value = value
        self.instantiate_value = ''

    def __repr__(self):
        return f'{self.name} = {self.value}'
    
    def add_instantiate_value(self, value):
        self.instantiate_value = value
    
    def instantiate(self):
        return f'.{self.name}({self.instantiate_value})'

class IO:
    def __init__(self, name, direction, width=None):
        self.name = name
        self.direction = direction
        self.width = width
        self.instantiate_value = ''

    def __repr__(self):
        if self.width:
            if type(self.width) == int:
                return f'{self.direction} [{self.width - 1}:0] {self.name}'
            else:
                return f'{self.direction} [{self.width} - 1:0] {self.name}'
        else:
            return f'{self.direction} {self.name}'
        
    def add_instantiate_value(self, value):
        self.instantiate_value = value
    
    def instantiate(self):
        return f'.{self.name}({self.instantiate_value})'
        

class Module:
    def __init__(self, name):
        self.name = name
        self.IOs = []
        self.parameters = []
        self.modules = []

    def __repr__(self):
        return f'module {self.name} {self.print_parameters()}{self.print_IOs()}\n{self.instantiate_modules()}\nendmodule'

    def add_IO(self, IO):
        self.IOs.append(IO)

    def add_parameter(self, parameter):
        self.parameters.append(parameter)

    def add_module(self, module, instance_name):
        string = f'{module.instantiate(instance_name)}'
        self.modules.append(string)

    def print_parameters(self):
        param_str = ', '.join(map(lambda x: str(x), self.parameters))
        return f'#(parameter {param_str})\n'
    
    def print_IOs(self):
        IOs_str = ',\n\t'.join(map(lambda x: str(x), self.IOs))
        return f'(\n\t{IOs_str}\n);\n'
        
    def instantiate_parameters(self):
        param_str = ', '.join(map(lambda x: x.instantiate(), self.parameters))
        return f'#({param_str})'
    
    def instantiate_IOs(self):
        IOs_str = ',\n\t'.join(map(lambda x: x.instantiate(), self.IOs))
        return f'(\n\t{IOs_str}\n);\n'
    
    def instantiate_modules(self):
        return '\n'.join(self.modules)
    
    def instantiate(self, instance_name):
        return f'{self.name} {self.instantiate_parameters()} {instance_name} {self.instantiate_IOs()}'

    

if __name__ == '__main__':
    l_idx = 1
    num_neurons = 30
    layer_1 = Module(f'layer_{l_idx}')
    parameters_1 = [('NUM_NEURON', 30), ('LAYER_ID', 1), ('NUM_WEIGHT', 784), ('DATA_WIDTH', 16), ('SIGMOID_SIZE', 10), ('ACT_TYPE', '"SIGMOID"')]
    IOs_1 = [('i_clk', 'input'), ('i_reset', 'input'), ('i_input', 'input', 'DATA_WIDTH'), ('i_input_valid', 'input'), ('o_input_ready', 'output'),
             ('i_weight', 'input', 32), ('i_weight_valid', 'input'), ('i_bias', 'input', 32), ('i_bias_valid', 'input'), ('i_layer_id', 'input', 32),
             ('i_neuron_id', 'input', 32), ('o_output', 'output', 'NUM_NEURON * DATA_WIDTH'), ('o_output_valid', 'output', 'NUM_NEURON')]

    for param in parameters_1:
        param_inst = Parameter(*param)
        layer_1.add_parameter(param_inst)

    for io in IOs_1:
        io_inst = IO(*io)
        layer_1.add_IO(io_inst)

    for i in range(num_neurons):
        neuron = Module('neuron')
        parameters = [('LAYER_ID', 1), ('NEURON_ID', 0), ('NUM_WEIGHT', 784), ('DATA_WIDTH', 16), ('SIGMOID_SIZE', 10), ('ACT_TYPE', '"SIGMOID"'),
                    ('WEIGHT_FILE', ''), ('BIAS_FILE', ''), ('SIGMOID_FILE', '')]
        IOs = [('i_clk', 'input'), ('i_reset', 'input'), ('i_input', 'input', 'DATA_WIDTH'), ('i_input_valid', 'input'), ('o_input_ready', 'output'),
                ('i_weight', 'input', 32), ('i_weight_valid', 'input'), ('i_bias', 'input', 32), ('i_bias_valid', 'input'), ('i_layer_id', 'input', 32),
                ('i_neuron_id', 'input', 32), ('o_output', 'output', 'DATA_WIDTH'), ('o_output_valid', 'output')]

        parameter_inst_values = ['LAYER_ID', 0, 'NUM_WEIGHT', 'DATA_WIDTH', 'SIGMOID_SIZE', 'ACT_TYPE', f'"w_{l_idx}_{i}.mif"', f'"b_{l_idx}_{i}.mif"', '"sig_contents.mif"']
        
        for idx, param in enumerate(parameters):
            param_inst = Parameter(*param)
            param_inst.add_instantiate_value(parameter_inst_values[idx])
            neuron.add_parameter(param_inst)

        io_inst_values = ['i_clk', 'i_reset', 'i_input', 'i_input_valid', 'o_input_ready', 'i_weight', 'i_weight_valid', 'i_bias', 'i_bias_valid', 'i_layer_id', 'i_neuron_id', f'o_output[{i} * DATA_WIDTH +: DATA_WIDTH]', f'o_output_valid[{i}]']
        
        for idx, io in enumerate(IOs):
            io_inst = IO(*io)
            io_inst.add_instantiate_value(io_inst_values[idx])
            neuron.add_IO(io_inst)

        layer_1.add_module(neuron, f'neuron_{i}')

    
    with open(fr'..\SystemVerilog\layer_{l_idx}.sv', 'w+') as file:
        file.write(str(layer_1))

    print('hi')