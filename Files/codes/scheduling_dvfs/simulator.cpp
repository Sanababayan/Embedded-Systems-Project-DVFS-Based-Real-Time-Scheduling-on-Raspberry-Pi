#include <bits/stdc++.h>

using namespace std;

const char* scheduled_file = "output.txt";
const char* bash_file = "simulator.sh";

struct Task {
    int core_number;
    string file_name;
    int core_frequency;
    double deadline;
};

int main() {
    string filename = scheduled_file;
    ifstream inputFile(filename);

    if (!inputFile) {
        cerr << "Error: Unable to open file " << scheduled_file << endl;
        return 1;
    }

    vector<Task> tasks;
    string line;

    while (getline(inputFile, line)) {
        stringstream ss(line);
        Task task;
        ss >> task.core_number >> task.file_name >> task.core_frequency >> task.deadline;
        
        if (ss.fail()) {
            cerr << "Error: Invalid format in file " << scheduled_file << endl;
            continue;
        }

        tasks.push_back(task);
    }

    inputFile.close();

    unordered_map<int, ofstream> core_scripts;
    for (int i = 0; i < 4; i++) {
        string filename = "core_" + to_string(i) + ".sh";
        core_scripts[i].open(filename);
        if (!core_scripts[i]) {
            cerr << "Error: Unable to create script file " << scheduled_file << endl;
            return 1;
        }
        
        core_scripts[i] << "#!/bin/bash\n\n";
        core_scripts[i] << "LOG_FILE=core_" << i << "_log.txt\n";
        core_scripts[i] << "echo 'Core " << i << " Execution Log' > $LOG_FILE\n";
        core_scripts[i] << "FIRST_TIME=$(date +%s.%N)\n";
    }

    

    for (const auto& task : tasks) {
        ofstream& script = core_scripts[task.core_number];

        script << "echo 'Setting Core " << task.core_number << " to " << task.core_frequency << " MHz'\n";
        script << "sudo cpufreq-set -c " << task.core_number << " -f " << task.core_frequency << "Mhz\n";
        
        script << "echo 'Running " << task.file_name << " on Core " << task.core_number << "'\n";

        
        script << "taskset -c " << task.core_number << " ./benchmarks/" << task.file_name << "/runme_large.sh\n";
        
        script << "END_TIME=$(date +%s.%N)\n";
        
        script << "TURN_TIME=$(echo \"$END_TIME - $FIRST_TIME\" | bc)\n";

        script << "if (( $(echo \"$TURN_TIME > " << task.deadline << "\" | bc -l) )); then\n";
        script << "    echo \"Task " << task.file_name << " on Core " << task.core_number << " MISSED DEADLINE! Took $TURN_TIME sec, deadline was " << task.deadline << " sec\" >> $LOG_FILE\n";
        script << "else\n";
        script << "    echo \"Task " << task.file_name << " on Core " << task.core_number << " met deadline. Took $TURN_TIME sec, deadline was " << task.deadline << " sec\" >> $LOG_FILE\n";
        script << "fi\n";
    }

    for (int i = 0; i < 4; i++) {
        core_scripts[i].close();
        string chmod_cmd = "chmod +x core_" + to_string(i) + ".sh";
        system(chmod_cmd.c_str());
    }

    ofstream master_script(bash_file);
    if (!master_script) {
        cerr << "Error: Unable to create master script file!" << endl;
        return 1;
    }

    master_script << "#!/bin/bash\n\n";
    master_script << "echo 'Starting all cores in parallel...'\n";

    for (int i = 0; i < 4; i++) {
        master_script << "./core_" << i << ".sh &\n";
    }

    master_script << "wait\n";
    master_script << "echo 'All core scripts have started their tasks.'\n";

    master_script.close();

    system("chmod +x simulator.sh");

    cout << "Generated 4 core scripts and one master script successfully!" << endl;
    return 0;
}