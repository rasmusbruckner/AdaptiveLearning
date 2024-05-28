# Cannon Task

This repository contains the code of the cannon task. The task is used to examine adaptive learning under uncertainty and in changing environments. 

The confetti-cannon task is the official task of the [Research Unit 5389](https://www.uni-hamburg.de/ru5389/research-unit.html) on "Contextual influences on dynamic belief updating in volatile environments: Basic mechanisms and clinical implications". The research unit is a collaboration between University of Hamburg, UKE Hamburg, Freie Universität Berlin, Humboldt-Universität zu Berlin, and Universität Jena.

The task was also used in:

* Nassar, M.R., Bruckner, R., & Frank, M.J. (2019). 
Statistical context dictates the relationship between feedback-related EEG signals and learning. <em>eLife</em>, 8:e46975 [Link](https://elifesciences.org/articles/46975)

The repository is frequently updated in the context of additional studies that use the task. Go to branch „franklabEEG“ (commit number a0b782e) for the version that was used in the paper. 

## Task Versions: Research Unit

For the research unit and related projects, we have different task versions.

### Common confetti-cannon task
	
The common version is used across most projects and allows us to compare adaptive learning under uncertainty across different populations and with different methods. Currently, the task is compatible with

* Pupillometry
* fMRI (PI: Lars Schwabe)
* EEG (PI: Anja Riesel)
* MEG (PI: Tobias Donner).

To run the common version, we recommend using a local config file. Since the version is shared across many labs, and every lab has its own local settings, we implemented a local config file that is specific to each lab. To create your own config file, use <em>al_commonConfettiConfigExample</em> as a template and update it with your own settings. Please put it outside of the git path to ensure that it is not pushed to GitHub (but remains a local config file just for your own purpose).
	
### EEG version

There is also a more specific EEG version focusing on social versus monetary feedback. The task is still under construction, and a few updates will be implemented in the next couple of weeks. PIs: Anja Riesel and Tania Lincoln.

To run this version, you should also use a config file. Start from the example <em>al_confettiEEGConfigExample</em> and follow the same procedure as explained above.

### Asymmetric-reward version

The asymmetric-reward version gives different kinds of feedback inducing an interesting reward bias. Work in progress. PI: Jan Gläscher.

Run the version using <em>RunAsymRewardVersion</em>. If this version is used eventually, we will create a separate config file as well.

### Variability-working-memory version

This version examines the role of different degrees of variability or risk and working memory. Also work in progress. PI: Jan Gläscher.

Run the version using <em>RunVarianceWorkingMemoryVersion</em>. If this version is used eventually, we will create a separate config file as well.

### Leipzig

This is a preliminary version with a helicopter instead of a cannon and might be used in the future to examine OCD.

Run the version using <em>RunLeipzigVersion</em>. If this version is used eventually, we will create a separate config file as well.

## Task Versions: Other

### Sleep

We combined the cannon task with a sleep-deprivation manipulation in Magdeburg.

Run the version using <em>RunSleepVersion</em>.

### MagdeburgFMRI

We are currently scanning the cannon task in Magdeburg.

Run the version using <em>RunMagdeburgFMRIVersion</em>.

### Dresden

The very first version of the cannon task developed in Dresden and at Brown University.

Run the version using <em>RunDresdenVersion</em>.

## Unit Tests

Two classes implement crucial unit tests

* <em>al_unittests</em>: Important functions
* <em>al_testTaskDataMain</em>: Class for the outcomes and data storage

## Integration Tests

We currently have two integration tests

* al_commonConfettiIntegrationTest  
* al_sleepIntegrationTest

All research-unit versions will ultimately be tested. You can also run all unit- and integration tests at the same time: <em>al_runAllTests</em>.

## Common Parameters

Since the research unit aims to compare the results across different experiments and task versions, it is crucial to share important task parameters. In the next couple of days, we will document these parameter settings here. 

## Built With

* [Matlab](https://www.mathworks.com/products/matlab.html)
* [Psychtoolbox-3](http://psychtoolbox.org)

## Author

* **Rasmus Bruckner** - [GitHub](https://github.com/rasmusbruckner) - [Freie Universität Berlin](https://www.ewi-psy.fu-berlin.de/en/einrichtungen/arbeitsbereiche/neural_dyn_of_vis_cog/learning-lab/team/bruckner/index.html) - [Universität Hamburg](https://www.psy.uni-hamburg.de/en/arbeitsbereiche/allgemeine-psychologie/personen/rasmus-bruckner.html)

## Acknowledgments

Over the years, several people have contributed to the task:

Matt Nassar, Ben Eppinger, Lennart Wittkuhn, Owen Parsons, Jan Gläscher, and the research-unit team

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
