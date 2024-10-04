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
        reduceShieldHeader
        reduceShield
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
        showCannonText
        addCannonText
        cannonFeedbackText
        practiceBlockFailHeader
        practiceBlockFail
        firstPupilBaselineHeader
        firstPupilBaseline
        secondPupilBaselineHeader
        secondPupilBaseline
        introduceLowNoiseHeader
        introduceLowNoise
        introduceHighNoiseHeader
        introduceHighNoise
        dynamicFeedbackTxt
        dynamicFeedbackHeader
        introducePassiveViewingHeader
        introducePassiveViewing
        dynamicBlockTxt

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
                self.welcomeText = 'Herzlich Willkommen zur Konfetti-Kanonen-Aufgabe!';
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
                self.introduceCannon = ['You are looking from above at a confetti cannon placed in the center of a circle. Your task is to catch the confetti with a bucket. Use the pink dot '...
                    'to indicate where you would like to place your bucket to catch the confetti. '...
                    'You can move the pink dot using the mouse.'];
            else
                error('language parameter unknown')
            end

            % Introduce confetti
            if isequal(self.language, 'German')
                self.introduceConfetti = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Steuern Sie den rosafarbenen Punkt auf den Kreis und drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';
            elseif isequal(self.language, 'English')
                self.introduceConfetti = 'The aim of the cannon is indicated by the black line. Hit the left mouse button to fire the cannon.';
            else
                error('language parameter unknown')
            end

            % Introduce spot
            if isequal(self.language, 'German')
                self.introduceSpot = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
                    'letzte Position Ihres Eimers. Steuern Sie den rosafarbenen Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];
            elseif isequal(self.language, 'English')
                self.introduceSpot = ['The black line shows the central position of the last confetti burst. The pink line shows the '...
                    'last position of your bucket. Now move the pink dot to the aim of the confetti cannon and press the left mouse button.'];
            else
                error('language parameter unknown')
            end

            % Introduce shield
            if isequal(self.language, 'German')
                self.introduceShield = 'Nach dem Kanonenschuss sehen Sie den Eimer. Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';
            elseif isequal(self.language, 'English')
                self.introduceShield = ['After the cannon is shot you will see the bucket. '...
                    'If you catch at least half of the confetti with the bucket, it is considered a "catch" and you get a point. '];
            else
                error('language parameter unknown')
            end

            % Introduce miss
            if isequal(self.language, 'German')
                self.introduceMiss = 'Versuchen Sie nun, Ihren Eimer so zu positionieren, dass Sie das Konfetti verfehlen. Drücken Sie dann die linke Maustaste.';
            elseif isequal(self.language, 'English')
                self.introduceMiss = ['Now try to place the bucket so that you miss the confetti. Then press '...
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
                self.firstPracticeHeader = 'First Practice Run';
            else
                error('language parameter unknown')
            end

            % First practice
            if isequal(self.language, 'German')
                self.firstPractice = ['In diesem Durchgang ist die Konfetti-Kanone schon sehr alt und die Schüsse sind daher ziemlich ungenau. Das heißt, auch wenn '...
                    'Sie den Eimer genau auf das Ziel der Konfetti-Kanone positionieren, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig. '...
                    'Dennoch fangen Sie am meisten Konfetti, wenn Sie den rosafarbenen Punkt genau auf die Stelle '...
                    'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
                    'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosafarbenen Punkt bitte immer auf die anvisierte '...
                    'Stelle.\n\nAchten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'];
            elseif isequal(self.language, 'English')
                self.firstPractice = ['In this block, the confetti cannon is very old '...
                    'and its aim therefore pretty inaccurate. Even if you move the bucket to the exact aim of the confetti cannon, '...
                    'you might miss the confetti. This inaccuracy is random. '...
                    'Still, your best strategy is to place the '...
                    'bucket in the location where the cannon is '...
                    'aimed.\n\nThe purpose of this practice session is to familiarize yourself with the inaccuracy '...
                    'of the confetti cannon. Please always aim the pink dot at the '...
                    'aim of the cannon.'];
            else
                error('language parameter unknown')
            end

            % Reduced shield header
            if isequal(self.language, 'German')
                self.reduceShieldHeader = 'Illustration Ihres Eimers';
            elseif isequal(self.language, 'English')
                self.reduceShieldHeader = 'Demonstration of your bucket';
            else
                error('language parameter unknown')
            end

            % Reduced
            if isequal(self.language, 'German')
                self.reduceShield = ['Ab jetzt sehen Sie den Eimer nur noch mit zwei Strichen dargestellt. Außerdem sehen Sie die Aufgabe in weniger Farben. ' ...
                    'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
                    'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und Blinzeln '...
                    'so gut es geht zu vermeiden.\n\n'...
                    'Jetzt folgt zunächst eine kurze Demonstration, wie der Eimer mit Strichen im Vergleich zum Eimer der vorherigen Übung aussieht.'];
            elseif isequal(self.language, 'English')
                self.reduceShield = 'Please update if you plan to use this.';
            else
                error('language parameter unknown')
            end

            % Second practice header
            if isequal(self.language, 'German')
                self.secondPracticeHeader = 'Zweiter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.secondPracticeHeader = 'Second Practice Run';
            else
                error('language parameter unknown')
            end

            % Second practice
            if isequal(self.language, 'German')
                self.secondPractice = ['Um sicherzugehen, dass Sie die Aufgabe verstanden haben, machen wir jetzt eine kurze Übung:\n\n'...
                    'Sie werden hintereinander fünf Schüsse der Konfetti-Kanone sehen. Danach geben Sie bitte an, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
                    'Die beste Strategie ist, die mittlere Position der Schüsse anzugeben. Diese Position ist die beste Vohersage, um in der Aufgabe am meisten Konfetti zu fangen.'];

            elseif isequal(self.language, 'English')
                self.secondPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

            % Third practice header
            if isequal(self.language, 'German')
                self.thirdPracticeHeader = 'Dritter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.thirdPracticeHeader = 'Third Practice Run';
            else
                error('language parameter unknown')
            end

            % Third practice
            if isequal(self.language, 'German')
                self.thirdPractice = ['In dieser Übung sehen Sie nur noch einen Schuss der Konfetti-Kanone. '...
                    'Bitte geben Sie wieder an, wo Sie die Konfetti-Kanone vermuten.\n\nBitte beachten Sie, dass das Ziel der Kanone meistens gleich bleibt. Manchmal richtet sich die Kanone allerding neu aus. '...
                    'Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
                    'dorthin bewegen.\n\nBeachten Sie, dass Sie das Konfetti trotz guter Vorhersagen auch häufig nicht fangen können.'];
            elseif isequal(self.language, 'English')
                self.thirdPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

            % Fourth practice header
            if isequal(self.language, 'German')
                self.fourthPracticeHeader = 'Vierter Übungsdurchgang';
            elseif isequal(self.language, 'English')
                self.fourthPracticeHeader = 'Fourth Practice Run';
            else
                error('language parameter unknown')
            end

            % Fourth practice
            if isequal(self.language, 'German')
                self.fourthPractice = ['Jetzt kommen wir zur letzten Übung.\n\nDiesmal müssen Sie mit dem rosafarbenen Punkt Ihr Schild platzieren und sehen dabei die Kanone nicht mehr. Außerdem werden Sie es sowohl mit einer relativ genauen '...
                    'als auch einer eher ungenauen versteckten Konfetti-Kanone zu tun haben.\n\n'...
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'...
                    '\n\nBeachten Sie bitte auch, dass das Ziel der Konfetti-Kanone in manchen Fällen sichtbar sein wird. In diesen Fällen ist die beste Strategie, zum Ziel der Kanone zu gehen.'];

            elseif isequal(self.language, 'English')
                self.fourthPractice = ['Add instructions please']; % update few things if planning to use this
            else
                error('language parameter unknown')
            end

            % Start task header
            if isequal(self.language, 'German')
                self.startTaskHeader = 'Start des Experiments';
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
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.\n\nViel Erfolg!'];
            elseif isequal(self.language, 'English')
                self.startTask = ['You have completed the practice phase. To summarize, you catch the most confetti, '...
                    'when you move the bucket (pink dot) to the aim of the confetti cannon. Because you can usually no longer see the cannon, '...
                    'you will have to estimate the aim based on the last confetti bursts. Please note that despite '...
                    'good predictions, you often wont be able to catch it. \n\nIn a few cases, you will see the confetti cannon and can improve your performance '...
                    'by moving the bucket to its aim.\n\n'...
                    'Please avoid eye movements and blinking during a trial. If the dot in the middle is light grey at the end of a trial, you may blink.\n\nGood luck!'];            else
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
                self.accidentalCatchHeader = 'A catch, unfortunately!';
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

            % Show cannon
            if isequal(self.language, 'German')
                self.showCannonText = 'Bitte geben Sie an, wo Sie die Kanone vermuten.';
            elseif isequal(self.language, 'English')
                self.showCannonText = 'Please add instructions';
            else
                error('language parameter unknown')
            end

            % Additional show cannon text
            if isequal(self.language, 'German')
                self.addCannonText = ['\n\nDie grauen Striche zeigen die letzten Konfetti-Wolken.\n'...
                'Mit der Maus können Sie angeben, wo Sie die Kanone vermuten.'];
            elseif isequal(self.language, 'English')
                self.addCannonText = 'Please add instructions';
            else
                error('language parameter unknown')
            end

            % Cannon feedback text
            if isequal(self.language, 'German')
                self.cannonFeedbackText = '\n\nHier können Sie Ihre Angabe und die echte Konfetti-Kanone vergleichen.';
            elseif isequal(self.language, 'English')
                self.cannonFeedbackText = 'Please add instructions';
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
                    'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird durch die schwarzen Linie angezeigt.'];
            elseif isequal(self.language, 'English')
                self.practiceBlockFail = ['You have often placed your bucket next to the aim of the cannon. In the next '...
                    'phase, please try to aim the bucket directly at the target. The aim is indicated by the black line.'];
            else
                error('language parameter unknown')
            end

            % First pupil baseline
            if isequal(self.language, 'German')
                self.firstPupilBaselineHeader = 'Erste Pupillenmessung';
                self.firstPupilBaseline = ['Sie werden jetzt für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
                    'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
            elseif isequal(self.language, 'English')
                self.firstPupilBaselineHeader = 'First Pupil Assessment';
                self.firstPupilBaseline = ['Include correct instructions here'];
            else
                error('language parameter unknown')
            end

            % Second pupil baseline
            if isequal(self.language, 'German')
                self.secondPupilBaselineHeader = 'Zweite Pupillenmessung';
                self.secondPupilBaseline = ['Sie werden jetzt noch mal für drei Minuten verschiedene Farben auf dem Bildschirm sehen. '...
                    'Bitte fixieren Sie Ihren Blick währenddessen auf den kleinen Punkt in der Mitte des Bildschirms.'];
            elseif isequal(self.language, 'English')
                self.secondPupilBaselineHeader = 'Second Pupil Assessment';
                self.secondPupilBaseline = ['Include correct instructions here'];
            else
                error('language parameter unknown')
            end

            % Indicate low noise
            if isequal(self.language, 'German')
                self.introduceLowNoiseHeader = 'Genauere Konfetti-Kanone';
                self.introduceLowNoise = ['Im folgenden Block wird die Konfetti-Kanone relativ genau sein.\n\n'...
                    'Die Größe des Eimers kann sich von Durchgang '...
                    'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
                    'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
                    'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
                    'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
                    'Strich zeigt die Position der letzten Konfetti-Wolke.\n\n'...
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'];
            elseif isequal(self.language, 'English')
                self.introduceLowNoiseHeader = 'More accurate confetti cannon';
                self.introduceLowNoise = ['In the following block, the confetti cannon will be relatively accurate.\n\n'...
                    'The size of the bucket can change from trial '...
                    'to trial. You cannot influence this change '...
                    'nor can you predict it. Therefore, the best strategy is always to '...
                    'place the bucket exactly where you think the confetti cannon will be aimed.'];
            else
                error('language parameter unknown')
            end

            % Indicate high noise
            if isequal(self.language, 'German')
                self.introduceHighNoiseHeader = 'Ungenauere Konfetti-Kanone';
                self.introduceHighNoise = ['Im folgenden Block wird die Konfetti-Kanone relativ ungenau sein.\n\n'...
                    'Die Größe des Eimers kann sich von Durchgang '...
                    'zu Durchgang ändern. Diese Veränderung können Sie nicht beeinflussen '...
                    'und auch nicht vorhersagen. Daher ist es immer die beste Strategie, '...
                    'den Eimer genau dorthin zu stellen, wo Sie das Ziel der Konfetti-Kanone vermuten.\n\n'...
                    'Zur Erinnerung: Der rosafarbene Strich zeigt Ihre letzte Vorhersage. Der schwarze '...
                    'Strich zeigt die Position der letzten Konfetti-Wolke.\n\n'...
                    'Achten Sie bitte auf Augenbewegungen und Blinzeln wie von der Versuchsleitung erklärt.'];
            elseif isequal(self.language, 'English')
                self.introduceHighNoiseHeader = 'Less accurate confetti cannon';
                self.introduceHighNoise = ['In the following block, the confetti cannon will be relatively inaccurate.\n\n'...
                    'The size of the bucket can change from trial '...
                    'to trial. You cannot influence this change '...
                    'nor can you predict it. Therefore, the best strategy is always to '...
                    'place the bucket exactly where you think the confetti cannon will be aimed.'];
            else
                error('language parameter unknown')
            end

            self.introducePassiveViewingHeader = 'Beobachtungsaufgabe';
            self.introducePassiveViewing = ['Versuchen Sie in dieser Aufgabe bitte in die Mitte '...
                'des Bildschirms zu fixieren. Es ist wichtig, dass Sie Ihre Augen nicht bewegen!\n\n'...
                'Versuchen Sie nur zu blinzeln, wenn der weiße Punkt erscheint.'];

        end


        function self = giveFeedback(self, currPoints, type)
            %GIVEFEEDBACK This function displays feedback after a block or
            %the task
            %
            %   Input
            %       self: Instructions-text-object instance
            %       currPoints: Number of points
            %       type: Single-block vs. whole task feedback
            %
            %   Output
            %       self: Instructions-text-object instance


            if isequal(type, 'block')
                if isequal(self.language, 'German')
                    self.dynamicFeedbackTxt = sprintf('In diesem Block haben Sie %.0f Punkte verdient.', currPoints);
                elseif isequal(self.language, 'English')
                    self.dynamicFeedbackTxt = sprintf('You have earned %.0f points in this block.', currPoints);
                else
                    error('language parameter unknown')
                end

            elseif isequal(type, 'task')
                if isequal(self.language, 'German')
                    self.dynamicFeedbackHeader = 'Ende des Versuchs!';
                    self.dynamicFeedbackTxt = sprintf('Vielen Dank für Ihre Teilnahme!\n\n\nSie haben insgesamt %i Punkte gewonnen!', currPoints);
                elseif isequal(self.language, 'English')
                    self.dynamicFeedbackHeader = 'End of the Experiment!';
                    self.dynamicFeedbackTxt = sprintf('Thank you for taking part!\n\n\nYou have won a total of %i points!', currPoints);
                else
                    error('language parameter unknown')
                end
            else
                error('type parameter unknown')
            end
        end


        function self = giveBlockFeedback(self, nBlocks, half, currBlock)
            %GIVEBLOCKFEEDBACK This function displays how many blocks have
            %been completed so far
            %
            %   Input
            %       self: Instructions-text-object instance
            %       nBlocks: Number of blocks
            %       half: Number of points
            %       currBlock: Indicates if we are in passive-viewing condition
            %   Output
            %       self: Instructions-text-object instance


            if half == 1
                self.dynamicBlockTxt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock, nBlocks*2);
            elseif half == 2
                self.dynamicBlockTxt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock+nBlocks, nBlocks*2);
            else
                error('half parameter undefined')
            end
        end

    end
end