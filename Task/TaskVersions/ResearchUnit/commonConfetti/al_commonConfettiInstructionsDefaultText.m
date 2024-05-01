classdef al_commonConfettiInstructionsDefaultText
    %AL_COMMONCONFETTIINSTRUCTIONSDEFAULTTEXT This class-definition file
    % specifiec the properties of the instruction text.
    %
    % The advantage of this kind of text file is that most text is in one
    % place and a local file can replace (specified in the config file) the
    % default file so that local differences are not tracked on GitHub.

    properties

        language
        welcomeText
        introduceCannon
        introduceConfetti
        introduceSpot
        introduceShield
        introduceMiss
        introduceMissBucket
        introducePracticeSession
        firstPracticeHeader
        firstPractice
        secondPracticeHeader
        secondPractice
        thirdPracticeHeader
        thirdPractice
        fourthPracticeHeader
        fourthPractice
        startTaskHeader
        startTask
        noCatchHeader
        noCatch
        accidentalCatchHeader
        accidentalCatch
        practiceBlockFailHeader
        practiceBlockFail

    end

    methods

        function self = al_commonConfettiInstructionsDefaultText(language)
            % This function creates an object of
            % class al_commonConfettiInstructionsDefaultText
            %
            %   Input
            %       language: Optional parameter specifying language (default German)
            %
            %   Output
            %       None


            % Check if language parameter is provided
            if ~exist('language', 'var') || isempty(language)
                self.language = 'German';
            else
                self.language = language;
            end

            % First message when starting task
            if isequal(self.language, 'German')
                self.welcomeText = 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!';
            elseif isequal(self.language, 'English')
                self.welcomeText = 'Welcome to the confetti-cannon task!';
            else
                error('language parameter unknown')
            end

            % Introduce cannon
            if isequal(self.language, 'German')
                self.introduceCannon = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
                    'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
                    'Maus steuern.'];
            elseif isequal(self.language, 'English')
                self.introduceCannon = ['A cannon is aimed at the circle. Indicate where '...
                    'you would like to place your shield to catch confetti with the pink spot. '...
                    'You can move the pink spot using the mouse.'];
            else
                error('language parameter unknown')
            end

            % Introduce confetti
            if isequal(self.language, 'German')
                self.introduceConfetti = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
            elseif isequal(self.language, 'English')
                self.introduceConfetti = 'The aim of the cannon is indicated with the black line. Hit the left mouse button to initiate a cannon shot.';
            else
                error('language parameter unknown')
            end

            % Introduce spot
            if isequal(self.language, 'German')
                self.introduceSpot = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
                    'Position Ihres letzten Eimers. Steuern Sie den rosa Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
            elseif isequal(self.language, 'English')
                self.introduceSpot = ['The black line shows you the central position of the last confetti cloud. The pink line shows you the '...
                    'position of your last bucket. Now move the pink dot to the aim of the confetti cannon and press the left mouse button.'];
            else
                error('language parameter unknown')
            end

            % Introduce shield
            if isequal(self.language, 'German')
                self.introduceShield = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
            elseif isequal(self.language, 'English')
                self.introduceShield = ['After the cannon is shot you will see the bucket. In this case you caught the '...
                    'confetti. If at least half of the confetti overlaps with the bucket then it is a "catch".'];
            else
                error('language parameter unknown')
            end

            % Introduce miss
            if isequal(self.language, 'German')
                self.introduceMiss = 'Versuchen Sie nun Ihren Eimer so zu positionieren, dass Sie das Konfetti verfehlen. Drücken Sie dann die linke Maustaste.';
            elseif isequal(self.language, 'English')
                self.introduceMiss = ['Now try to place the bucket so that you miss the confetti. Then hit '...
                    'the left mouse button. '];
            else
                error('language parameter unknown')
            end

            % Introduce miss with bucket
            if isequal(self.language, 'German')
                self.introduceMissBucket = 'In diesem Fall haben Sie das Konfetti verfehlt.';
            elseif isequal(self.language, 'English')
                self.introduceMissBucket = 'In this case you missed the confetti.';
            else
                error('language parameter unknown')
            end

            % Introduce practice session
            if isequal(self.language, 'German')
                self.introducePracticeSession = 'Im Folgenden durchlaufen Sie ein paar Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';
            elseif isequal(self.language, 'English')
                self.introducePracticeSession = 'In the following, you will go through a few practice runs\nand then two blocks of the experiment.';
            else
                error('language parameter unknown')
            end

            % First practice header
            if isequal(self.language, 'German')
                self.firstPracticeHeader = 'Erster Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.firstPracticeHeader = 'First Practice';
            else
                error('language parameter unknown')
            end

            % First practice
            if isequal(self.language, 'German')
                self.firstPractice = ['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
                    'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
                    'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
                    'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
                    'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
                    'Stelle.'];
            elseif isequal(self.language, 'English')
                self.firstPractice = ['In this block you will encounter a cannon '...
                    'that is not perfectly accurate. On some '...
                    'trials it might shoot a bit above where it is '...
                    'aimed and on other trials a bit below. '...
                    'Your best strategy is to place the '...
                    'bucket in the location where the cannon is '...
                    'aimed.\n\nThe purpose of this practice session is to familiarize you with the inaccuracy '...
                    'of the confetti cannon. Please always aim the pink dot at the '...
                    'aim of the cannon.'];
            else
                error('language parameter unknown')
            end

            % Second practice header
            if isequal(self.language, 'German')
                self.secondPracticeHeader = 'Zweiter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.secondPracticeHeader = 'Second Practice';
            else
                error('language parameter unknown')
            end

            % Second practice
            if isequal(self.language, 'German')
                self.secondPractice = ['Ab jetzt sehen Sie das Spiel ohne Animationen und mit weniger bunten Farben. In dieser Übung wird Ihr Eimer in der Mitte durchsichtig sein. ' ...
                    'Wie in der vorherigen Übung zählt es als Treffer, wenn mindestens die Hälfte der Konfetti-Wolke im Eimer gefangen wurde.\n\n'...
                    'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
                    'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie während eines Versuchs Augenbewegungen und blinzeln '...
                    'so gut es geht zu vermeiden.\n\nAm Ende eines Versuchs dürfen Sie blinzeln. Während dieser Phase ist der Punkt in der Mitte hellgrau.'];
            elseif isequal(self.language, 'English')
                self.secondPractice = ['From now on you will see the game without animations and with fewer bright colors. In this exercise, your bucket will be transparent in the middle. ' ...
                    'As in the previous exercise, it counts as a hit if at least half of the confetti cloud is caught in the bucket.\n\n'...
                    'This is necessary so that we can measure your pupil size properly. Therefore, please pay particular attention to '...
                    'fix your gaze on the dot in the center of the circle. Please try to avoid eye movements and blinking '...
                    'as much as possible.\n\nAt the end of a trial, you may blink. During this phase, the dot in the middle is light gray.'];
            else
                error('language parameter unknown')
            end

            % Third practice header
            if isequal(self.language, 'German')
                self.thirdPracticeHeader = 'Dritter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.thirdPracticeHeader = 'Third Practice';
            else
                error('language parameter unknown')
            end

            % Third practice
            if isequal(self.language, 'German')
                self.thirdPractice = ['Im nächsten Übungsdurchgang wird Ihr Eimer nur noch durch zwei Striche dargestellt. Achten Sie bitte weiterhin besonders darauf, '...
                    'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und blinzeln '...
                    'so gut es geht zu vermeiden. Am Ende eines Versuchs dürfen Sie blinzeln (angezeigt durch den hellgrauen Punkt in der Mitte).'];
            elseif isequal(self.language, 'English')
                self.thirdPractice = ['In the next practice run, your bucket will only be represented by two lines. Please continue to pay particular attention to '...
                    'to fix your gaze on the dot in the center of the circle. Please try to avoid eye movements and blinking '...
                    'as much as possible. At the end of a trial, you may blink (indicated by the light gray dot in the middle).'];

            else
                error('language parameter unknown')
            end

            % Fourth practice header
            if isequal(self.language, 'German')
                self.fourthPracticeHeader = 'Vierter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.fourthPracticeHeader = 'Fourth Practice';
            else
                error('language parameter unknown')
            end

            % Fourth practice
            if isequal(self.language, 'German')
                self.fourthPractice = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone sehen Sie dann einen Punkt. '...
                    'Außerdem sehen Sie, wo das Konfetti hinfliegt.\n\nUm weiterhin viel Konfetti zu fangen, müssen Sie aufgrund '...
                    'der Flugposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt und den Eimer auf diese Position '...
                    'steuern. Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
                    'dorthin bewegen.\n\nIn der folgenden Übung werden Sie es sowohl mit einer relativ genauen '...
                    'als auch einer eher ungenauen Konfetti-Kanone zu tun haben. Beachten Sie, dass Sie das Konfetti trotz '...
                    'guter Vorhersagen auch häufig nicht fangen können.'];
            elseif isequal(self.language, 'English')
                self.fourthPractice = ['In this practice run, the confetti cannon is no longer visible. Instead of the confetti cannon, you will see a dot. '...
                    'You can also see where the confetti is flying to.\n\nIn order to continue catching lots of confetti, you must predict where the confetti is flying to based on '...
                    'the previous shots. That way you can estimate where the confetti cannon is currently aiming and move the bucket to this position. '...
                    'If you think that the confetti cannon has changed direction, you should also move the bucket '...
                    'there.\n\nIn the following exercise, you will try it with both a relatively accurate '...
                    ' as well as a rather inaccurate confetti cannon. Please note that despite '...
                    'good predictions, you will often not be able to catch the confetti.'];
            else
                error('language parameter unknown')
            end

            % Start task header
            if isequal(self.language, 'German')
                self.startTaskHeader = 'Jetzt kommen wir zum Experiment';
            elseif isequal(self.language, 'English')
                self.startTaskHeader = 'Beginning of the Experiment';
            else
                error('language parameter unknown')
            end

            % Start task
            if isequal(self.language, 'German')
                self.startTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
                    'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
                    'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
                    'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
                    'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
                    'Achten Sie bitte auf Ihre Augenbewegungen und vermeiden Sie es während eines Versuchs zu blinzeln. Wenn der Punkt in der Mitte am Ende eines Versuchs hellgrau ist, dürfen Sie blinzeln.\n\nViel Erfolg!'];
            elseif isequal(self.language, 'English')
                self.startTask = ['You have completed the practice phase. So, to summarize, you catch the most confetti, '...
                    ' when you move the bucket (pink dot) to the aim of the confetti cannon. Because you can usually no longer see the cannon, '...
                    'you will have to estimate the aim based on the last confetti clouds. Please note that despite '...
                    'good predictions, you will often not be able to catch it. \n\nIn a few cases, you will see the confetti cannon and can improve your performance '...
                    'by moving the bucket towards the aim.\n\n'...
                    'Please pay attention to your eye movements and avoid blinking during a trial. If the dot in the middle is light gray at the end of a trial, you may blink.\n\nGood luck!'];            else
                error('language parameter unknown')
            end

            % No catch header
            if isequal(self.language, 'German')
                self.noCatchHeader = 'Leider nicht gefangen!';
            elseif isequal(self.language, 'English')
                self.noCatchHeader = 'Unfortunately no catch!';
            else
                error('language parameter unknown')
            end

            % No catch
            if isequal(self.language, 'German')
                self.noCatch = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';
            elseif isequal(self.language, 'English')
                self.noCatch = 'Unfortunately, you did not catch enough confetti. Try again!';
            else
                error('language parameter unknown')
            end

            % Accidental catch header
            if isequal(self.language, 'German')
                self.accidentalCatchHeader = 'Leider gefangen!';
            elseif isequal(self.language, 'English')
                self.accidentalCatchHeader = 'Unfortunately caught!';
            else
                error('language parameter unknown')
            end

            % Accidental catch
            if isequal(self.language, 'German')
                self.accidentalCatch = 'Sie haben zu viel Konfetti gefangen. Versuchen Sie bitte, das Konfetti zu verfehlen!';
            elseif isequal(self.language, 'English')
                self.accidentalCatch = 'You have caught too much confetti. Please try to miss the confetti!';
            else
                error('language parameter unknown')
            end

            % Practice block fail header
            if isequal(self.language, 'German')
                self.practiceBlockFailHeader = 'Bitte noch mal probieren!';
            elseif isequal(self.language, 'English')
                self.practiceBlockFailHeader = 'Please try again!';
            else
                error('language parameter unknown')
            end

            % Practice block fail
            if isequal(self.language, 'German')
                self.practiceBlockFail = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                    'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];
            elseif isequal(self.language, 'English')
                self.practiceBlockFail = ['You have often placed your bucket next to the aim of the cannon. In the next '...
                    ' pass, please try to aim the bucket directly at the target. The aim is shown with the needle.'];
            else
                error('language parameter unknown')
            end
        end

    end
end