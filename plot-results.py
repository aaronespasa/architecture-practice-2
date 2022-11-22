"""
Use Matplotlib to create the plots from the results of the experiments.
The results can be found in the results directory.
File structure:
    results
        rendimiento
            gauss
                aos
                soa
            histo
                aos
                soa
            mono
                aos
                soa
        energia
            gauss
                aos
                soa
            histo
                aos
                soa
            mono
                aos
                soa
"""
import os
import sys
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

RESULTS_DIR = 'results'
PLOTS_DIR = 'plots'
RESULT_TYPES = ['rendimiento', 'energia']
FUNCTION_TYPES = ['gauss', 'histo', 'mono']
STRUCTURE_TYPES = ['aos', 'soa']

GRAPH_X_LABEL = 'Number of threads'

def create_plot_folder():
    """Create the plots folder."""
    # remove the folder if it already exists
    if os.path.exists(PLOTS_DIR):
        os.system(f'rm -rf {PLOTS_DIR}')
    
    # create the folder
    os.mkdir(PLOTS_DIR)

    for type in RESULT_TYPES:
        os.mkdir(os.path.join(PLOTS_DIR, type))
        for function in FUNCTION_TYPES:
            os.mkdir(os.path.join(PLOTS_DIR, type, function))
            for structure in STRUCTURE_TYPES:
                os.mkdir(os.path.join(PLOTS_DIR, type, function, structure))

def extract_performance_info(file_name):
    """Extract the information from the file name for the energy plot."""
    # extract the information
    num_threads, _, schedule_type, _ = file_name.split('_')
    num_threads = int(num_threads.split('/')[-1])

    process_time = 0
    cycles = 0
    instructions = 0
    branches = 0
    branch_misses = 0
    with open(file_name, 'r') as file:
        for line in file:
            if 'Process time' in line:
                process_time = int(line.split(':')[1])
            elif 'cycles' in line:
                cycles = int(line.split('cycles')[0])
            elif 'instructions' in line:
                instructions = int(line.split('instructions')[0])
            elif 'branch-misses' in line:
                branch_misses = int(line.split('branch-misses')[0])
            elif 'branches' in line:
                branches = int(line.split('branches')[0])
    
    file_info = {
        'num_threads': num_threads,
        'schedule_type': schedule_type,
        'process_time': process_time,
        'cycles': cycles,
        'instructions': instructions,
        'branches': branches,
        'branch_misses': branch_misses
    }

    return file_info

def extract_energy_info(file_name):
    """Extract the information from the file name for the energy plot."""
    # extract the information
    num_threads, _, schedule_type, _ = file_name.split('_')
    num_threads = int(num_threads.split('/')[-1])

    process_time = 0
    energy_cores = 0
    energy_pkg = 0
    energy_ram = 0
    with open(file_name, 'r') as file:
        for line in file:
            if 'Process time' in line:
                process_time = int(line.split(':')[1])
            elif 'energy-cores' in line:
                energy_cores = float(line.split(' Joules ')[0])
            elif 'energy-pkg' in line:
                energy_pkg = float(line.split(' Joules ')[0])
            elif 'energy-ram' in line:
                energy_ram = float(line.split(' Joules ')[0])
    
    file_info = {
        'num_threads': num_threads,
        'schedule_type': schedule_type,
        'process_time': process_time,
        'energy_cores': energy_cores,
        'energy_pkg': energy_pkg,
        'energy_ram': energy_ram
    }

    return file_info

def fill_files_info(files_info, result_type, results_path):
    for file in os.listdir(results_path):
        if file.endswith(".txt"):
            if result_type == 'rendimiento':
                file_info = extract_performance_info(os.path.join(results_path, file))
            elif result_type == 'energia':
                file_info = extract_energy_info(os.path.join(results_path, file))
            for key in files_info.keys():
                files_info[key].append(file_info[key])

def generate_performance_plot(function, structure, results_path, plot_path):
    files_info = {
        'num_threads': [],
        'schedule_type': [],
        'process_time': [],
        'cycles': [],
        'instructions': [],
        'branches': [],
        'branch_misses': []
    }
    fill_files_info(files_info, 'rendimiento', results_path)
    graph_title = f'performance {function} {structure}'
    graph_name = f'performance_{function}_{structure}'
    graph_x_values = sorted(list(set(files_info['num_threads'])))
    GRAPH_Y_LABEL = 'Process time (ms)'

    for schedule_type in sorted(list(set(files_info['schedule_type']))):
        graph_y_values = [0] * len(graph_x_values)
        
        for i in range(len(files_info['num_threads'])):
            if files_info['schedule_type'][i] == schedule_type:
                graph_y_values[graph_x_values.index(files_info['num_threads'][i])] = files_info['process_time'][i]

        plt.plot(graph_x_values, graph_y_values, label=schedule_type)

    plt.title(graph_title)
    plt.xlabel(GRAPH_X_LABEL)
    plt.ylabel(GRAPH_Y_LABEL)
    plt.xticks(graph_x_values)
    plt.legend()
    plt.savefig(f"{plot_path}/{graph_name}.png")
    plt.clf()

def generate_energy_plot(function, structure, results_path, plot_path):
    files_info = {
        'num_threads': [],
        'schedule_type': [],
        'process_time': [],
        'energy_cores': [],
        'energy_pkg': [],
        'energy_ram': []
    }
    fill_files_info(files_info, 'energia', results_path)
    graph_title = f'energy {function} {structure}'
    graph_name = f'energy_{function}_{structure}'
    graph_x_values = sorted(list(set(files_info['num_threads'])))
    GRAPH_Y_LABEL = 'Energy cores (J)'

    for schedule_type in sorted(list(set(files_info['schedule_type']))):
        graph_y_values = [0] * len(graph_x_values)
        
        for i in range(len(files_info['num_threads'])):
            if files_info['schedule_type'][i] == schedule_type:
                graph_y_values[graph_x_values.index(files_info['num_threads'][i])] = files_info['energy_cores'][i]

        plt.plot(graph_x_values, graph_y_values, label=schedule_type)

    plt.title(graph_title)
    plt.xlabel(GRAPH_X_LABEL)
    plt.ylabel(GRAPH_Y_LABEL)
    plt.xticks(graph_x_values)
    plt.legend()
    plt.savefig(f"{plot_path}/{graph_name}.png")
    plt.clf()

def generate_plots():
    """Generate plots"""
    for result_type in RESULT_TYPES:
        for function in FUNCTION_TYPES:
            for structure in STRUCTURE_TYPES:
                relative_path = os.path.join(result_type, function, structure)
                results_path = os.path.join(RESULTS_DIR, relative_path)
                plot_path = os.path.join(PLOTS_DIR, relative_path)

                if result_type == 'rendimiento':
                    generate_performance_plot(function, structure, results_path, plot_path)
                elif result_type == 'energia':
                    generate_energy_plot(function, structure, results_path, plot_path)


if __name__ == "__main__":
    create_plot_folder()
    generate_plots()
