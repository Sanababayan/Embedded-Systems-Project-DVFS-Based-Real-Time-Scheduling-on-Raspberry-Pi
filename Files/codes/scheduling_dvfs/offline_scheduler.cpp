#include <bits/stdc++.h>

using namespace std;

#define MAX_TASKS 20
const char* CSV_FILE = "benchmark_profile.csv";
const char* INPUT_FILE = "test_case.in";
const char* OUTPUT_FILE = "output.txt";
const vector<int> FREQUENCIES = {600, 700, 800, 900, 1000, 1100, 1200};

struct Task_Type {
    string task_name;
    map <int, pair<double, double>> frequency_time_power; // key is frequency, first is time, second is power
};

struct Task {
    int core;
    struct Task_Type* task_type;
    double deadline;
    double end_time;
};

struct Core {
    int id;
    vector <struct Task*> tasks;
    vector<int> DVFS_frequencies;
    double total_power_consumption;
};


map<string, vector<pair<double, double>>> get_data_from_csv() {
    ifstream file(CSV_FILE);

    if (!file.is_open()) {
        cerr << "Error: Unable to open file!" << endl;
        return map<string, vector<pair<double, double>>>{};
    }

    string line;
    vector<string> program_names;
    

    map<string, vector<pair<double, double>>> program_data;

    if (getline(file, line)) {
        stringstream ss(line);
        string program;
        
        if (line[0] == ',') ss.ignore();

        while (getline(ss, program, ',')) {
            program_names.push_back(program);
            program_data[program] = {}; 
        }
    }

    int freq_index = 0;
    while (getline(file, line)) {
        stringstream ss(line);
        string value;
        vector<double> values;

        while (getline(ss, value, ',')) {
            if (!value.empty()) {
                values.push_back(stod(value)); 
            }
        }

        if (values.size() != program_names.size()) {
            cerr << "Error: Mismatched data columns!" << endl;
            return map<string, vector<pair<double, double>>>{};
        }

        if (!getline(file, line)) break;
        stringstream ss_power(line);
        vector<double> power_values;

        while (getline(ss_power, value, ',')) {
            if (!value.empty()) {
                power_values.push_back(stod(value));
            }
        }

        if (power_values.size() != program_names.size()) {
            cerr << "Error: Mismatched power data!" << endl;
            return map<string, vector<pair<double, double>>>{};
        }


        for (size_t i = 0; i < program_names.size(); i++) {
            program_data[program_names[i]].push_back({values[i], power_values[i]});
        }

        freq_index++;
        if (freq_index >= FREQUENCIES.size()) break;
    }

    file.close();

    return program_data;
}
 

map<string, struct Task_Type*> create_task_types() {
    map <string, struct Task_Type*> task_types;
    map <string, vector<pair<double, double>>> program_data = get_data_from_csv();

    for (auto it = program_data.begin(); it != program_data.end(); ++it) {
        struct Task_Type* tt = new Task_Type;
        int ind = 0;
        for (auto j = it->second.begin(); j != it->second.end(); ++j) {
            tt->frequency_time_power[FREQUENCIES[ind]] = {j->first, j->second};
            tt->task_name = it->first;
            ind++;
        }
        task_types[it->first] = tt;
    }

    return task_types;
}

struct Core** create_raspberry() {
    struct Core** cores = (struct Core**) malloc(sizeof(struct Core*) * 4);
    for (int i = 0; i != 4; i++) {
        cores[i] = new Core;
        cores[i]->id = i;
    }
    return cores;
}

void assign_tasks_to_cores(struct Core** cores, map<string, struct Task_Type*> task_types) {
    ifstream f(INPUT_FILE);

    if (!f.is_open()) {
        cerr << "Error opening the file!";
        return;
    }

    string s;

    while (getline(f, s)) {
        stringstream ss(s);
        vector<string> v;
        string part;

        while (getline(ss, part, ' ')) {
            v.push_back(part);
        }

        struct Task* task = new Task;
        task->core = stoi(v[0]);
        task->deadline = stod(v[2]);
        task->task_type = task_types[v[1]];
        task->end_time = -1;
        cores[task->core]->tasks.push_back(task);
    }


    f.close();
    return;
}

bool compareTasks(struct Task* a, struct Task* b) { // EDF
    return a->deadline < b->deadline;
}

void EDF_scheduling(struct Core** cores) {
    for (int i = 0; i != 4; i++) {
        struct Core* core = cores[i];
        sort(core->tasks.begin(), core->tasks.end(), compareTasks);
    }
}

bool is_deadline_missed(struct Core* core, vector<int> tasks_frequencies) {
    if (core->tasks.size() == 0)
        return false;
    struct Task* first_task = core->tasks[0];
    first_task->end_time = first_task->task_type->frequency_time_power[tasks_frequencies[0]].first;

    if (first_task->end_time > first_task->deadline) {
        return true;
    }

    for (int i = 1; i != tasks_frequencies.size(); i++) {
        struct Task* task = core->tasks[i];
        struct Task* last_task = core->tasks[i-1];
        task->end_time = last_task->end_time + task->task_type->frequency_time_power[tasks_frequencies[i]].first;
        if (task->end_time + 0.5 > task->deadline) {
            return true;
        }
    }
    return false;
}

void greedy_frequency_determiner(Core* core, vector<int> tasks_frequencies, double tasks_power_consumption) {
    if (tasks_frequencies.size() == core->tasks.size()) {
        if (is_deadline_missed(core, tasks_frequencies))
            return;
        if (tasks_power_consumption < core->total_power_consumption) {
            core->total_power_consumption = tasks_power_consumption;
            core->DVFS_frequencies = tasks_frequencies;
        }
        return;
    }
    int task_number = tasks_frequencies.size();
    for (int i = 0; i != 7; i++) {
        double original_power = tasks_power_consumption;

        tasks_frequencies.push_back(FREQUENCIES[i]);

        tasks_power_consumption += core->tasks[task_number]->task_type->frequency_time_power[FREQUENCIES[i]].second;
        
        
        if (!is_deadline_missed(core, tasks_frequencies) && core->total_power_consumption >= tasks_power_consumption) {
            greedy_frequency_determiner(core, tasks_frequencies, tasks_power_consumption);
        }
        tasks_frequencies.pop_back();

        tasks_power_consumption = original_power;
    }
}

bool DVFS(struct Core** cores) {
    for (int i = 0; i != 4; i++) {
        struct Core* core = cores[i];
        core->total_power_consumption = INT64_MAX;
        vector<int> tasks_frequencies;
        greedy_frequency_determiner(core, tasks_frequencies, 0);
        if (core->DVFS_frequencies.size() != core->tasks.size())
            return false;
    }
    return true;   
}

void write_scheduling_to_output_file(struct Core** cores) {
    ofstream file;
    file.open(OUTPUT_FILE);
    
    for (int i = 0; i != 4; i++) {
        for (int j = 0; j != cores[i]->tasks.size(); j++) {
            file << i << " " << cores[i]->tasks[j]->task_type->task_name << " " << cores[i]->DVFS_frequencies[j] 
                << " " << cores[i]->tasks[j]->deadline << endl;
        }
    }
    file.close();
}



int main() {
    struct Core** cores = create_raspberry();
    map <string, struct Task_Type*> all_task_types = create_task_types();
    assign_tasks_to_cores(cores, all_task_types);
    EDF_scheduling(cores);
    bool result = DVFS(cores);
    if (result) {
        write_scheduling_to_output_file(cores);
        cout << "Tasks are schedulable!" << endl << "Results are in output.txt";
    } else {
        cout << "Tasks are not schedulable";
    }
}