# Cannon Task

This repository contains the code of the adaptive-learning cannon task.

The task was used in:

* **Nassar, M.R., Bruckner, R., & Frank, M.J. (2019). 
Statistical context dictates the relationship between feedback-related EEG signals and learning. eLife, 8:e46975** [Link](https://elifesciences.org/articles/46975)

The repository is frequently updated in the context of additional studies that use the task. Go to branch „franklabEEG“ (commit number a0b782e) for the version that was used in the paper. 

## Getting Started

To run the task versions that are currently updated, go to the TaskVersions folder. The "sleep" and "Hamburg" versions are already tested based on unit and integration tests. The other versions are currently updated, so we will have independent task versions that rely on the same objects and core functions. Previously, all versions were combined in the "AdaptiveLearning" function, which will be removed soon. Since there are now so many different versions, it is easier when they are more independent. For questions, please get in touch with me.

## Built With

* [Matlab](https://www.mathworks.com/products/matlab.html)
* [Psychtoolbox-3](http://psychtoolbox.org)

## Author

* **Rasmus Bruckner** - [GitHub](https://github.com/rasmusbruckner) - [Freie Universität Berlin](https://www.ewi-psy.fu-berlin.de/en/einrichtungen/arbeitsbereiche/neural_dyn_of_vis_cog/learning-lab/team/bruckner/index.html)

## Acknowledgments

Over the years, several people have contributed to the task:

Matt Nassar, Ben Eppinger, Lennart Wittkuhn, & Owen Parsons.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
