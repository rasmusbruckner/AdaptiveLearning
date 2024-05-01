classdef al_commonConfettiInstructionsDefaultText
    %AL_COMMONCONFETTIINSTRUCTIONSDEFAULTTEXT This class-definition file
    % specifiec the properties of the instruction text.
    %
    % The advantage of this kind of text file is that most text is in one
    % place and a local file can replace (specified in the config file) the
    % default file so that local differences are not tracked on GitHub.

    properties

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

        function self = al_commonConfettiInstructionsDefaultText()

            % First message when starting task
            self.welcomeText = 'Herzlich Willkommen Zur Konfetti-Kanonen-Aufgabe!';

            % Introduce cannon
            self.introduceCannon = ['Sie blicken von oben auf eine Konfetti-Kanone, die in der Mitte eines Kreises positioniert ist. Ihre Aufgabe ist es, das Konfetti mit einem Eimer zu fangen. Mit dem rosafarbenen '...
                'Punkt können Sie angeben, wo auf dem Kreis Sie Ihren Eimer platzieren möchten, um das Konfetti zu fangen. Sie können den Punkt mit der '...
                'Maus steuern.'];

            % Introduce confetti
            self.introduceConfetti = 'Das Ziel der Konfetti-Kanone wird mit der schwarzen Linie angezeigt. Drücken Sie die linke Maustaste, damit die Konfetti-Kanone schießt.';

            % Introduce spot
            self.introduceSpot = ['Der schwarze Strich zeigt Ihnen die mittlere Position der letzten Konfettiwolke. Der rosafarbene Strich zeigt Ihnen die '...
                'Position Ihres letzten Eimers. Steuern Sie den rosa Punkt jetzt bitte auf das Ziel der Konfetti-Kanone und drücken Sie die linke Maustaste.'];

            % Introduce shield
            self.introduceShield = 'Wenn Sie mindestens die Hälfte des Konfettis im Eimer fangen, zählt es als Treffer und Sie erhalten einen Punkt.';

            % Introduce miss
            self.introduceMiss = 'Versuchen Sie nun Ihren Eimer so zu positionieren, dass Sie das Konfetti verfehlen. Drücken Sie dann die linke Maustaste.';

            % Introduce miss with bucket
            self.introduceMissBucket = 'In diesem Fall haben Sie das Konfetti verfehlt.';

            % Introduce practice session
            self.introducePracticeSession = 'Im Folgenden durchlaufen Sie ein paar Übungsdurchgänge\nund im Anschluss zwei Durchgänge des Experiments.';

            % First practice header
            self.firstPracticeHeader = 'Erster Übungsdurchgang';

            % First practice
            self.firstPractice = ['Weil die Konfetti-Kanone schon sehr alt ist, sind die Schüsse ziemlich ungenau. Das heißt, auch wenn '...
                'Sie genau auf das Ziel gehen, können Sie das Konfetti verfehlen. Die Ungenauigkeit ist zufällig, '...
                'dennoch fangen Sie am meisten Konfetti, wenn Sie den rosanen Punkt genau auf die Stelle '...
                'steuern, auf die die Konfetti-Kanone zielt.\n\nIn dieser Übung sollen Sie mit der Ungenauigkeit '...
                'der Konfetti-Kanone erst mal vertraut werden. Steuern Sie den rosanen Punkt bitte immer auf die anvisierte '...
                'Stelle.'];

            % Second practice header
            self.secondPracticeHeader = 'Zweiter Übungsdurchgang';

            % Second practice
            self.secondPractice = ['Ab jetzt sehen Sie das Spiel ohne Animationen und mit weniger bunten Farben. In dieser Übung wird Ihr Eimer in der Mitte durchsichtig sein. ' ...
                'Wie in der vorherigen Übung zählt es als Treffer, wenn mindestens die Hälfte der Konfetti-Wolke im Eimer gefangen wurde.\n\n'...
                'Dies ist notwendig, damit wir Ihre Pupillengröße gut messen können. Achten Sie daher bitte besonders darauf, '...
                'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie während eines Versuchs Augenbewegungen und blinzeln '...
                'so gut es geht zu vermeiden.\n\nAm Ende eines Versuchs dürfen Sie blinzeln. Während dieser Phase ist der Punkt in der Mitte hellgrau.'];

            % Third practice header
            self.thirdPracticeHeader = 'Dritter Übungsdurchgang';

            % Third practice
            self.thirdPractice = ['Im nächsten Übungsdurchgang wird Ihr Eimer nur noch durch zwei Striche dargestellt. Achten Sie bitte weiterhin besonders darauf, '...
                'Ihren Blick auf den Punkt in der Mitte des Kreises zu fixieren. Bitte versuchen Sie Augenbewegungen und blinzeln '...
                'so gut es geht zu vermeiden. Am Ende eines Versuchs dürfen Sie blinzeln (angezeigt durch den hellgrauen Punkt in der Mitte).'];

            % Fourth practice header
            self.fourthPracticeHeader = 'Vierter Übungsdurchgang';

            % Fourth practice
            self.fourthPractice = ['In diesem Übungsdurchgang ist die Konfetti-Kanone nicht mehr sichtbar. Anstelle der Konfetti-Kanone sehen Sie dann einen Punkt. '...
                'Außerdem sehen Sie, wo das Konfetti hinfliegt.\n\nUm weiterhin viel Konfetti zu fangen, müssen Sie aufgrund '...
                'der Flugposition einschätzen, auf welche Stelle die Konfetti-Kanone aktuell zielt und den Eimer auf diese Position '...
                'steuern. Wenn Sie denken, dass die Konfetti-Kanone ihre Richtung geändert hat, sollten Sie auch den Eimer '...
                'dorthin bewegen.\n\nIn der folgenden Übung werden Sie es sowohl mit einer relativ genauen '...
                'als auch einer eher ungenauen Konfetti-Kanone zu tun haben. Beachten Sie, dass Sie das Konfetti trotz '...
                'guter Vorhersagen auch häufig nicht fangen können.'];

            % Start task header
            self.startTaskHeader = 'Jetzt kommen wir zum Experiment';

            % Start task
            self.startTask = ['Sie haben die Übungsphase abgeschlossen. Kurz zusammengefasst fangen Sie also das meiste Konfetti, '...
                'wenn Sie den Eimer (rosafarbener Punkt) auf die Stelle bewegen, auf die die Konfetti-Kanone zielt. Weil Sie die Konfetti-Kanone meistens nicht mehr '...
                'sehen können, müssen Sie diese Stelle aufgrund der Position der letzten Konfettiwolken einschätzen. Beachten Sie, dass Sie das Konfetti trotz '...
                'guter Vorhersagen auch häufig nicht fangen können. \n\nIn wenigen Fällen werden Sie die Konfetti-Kanone zu sehen bekommen und können Ihre Leistung '...
                'verbessern, indem Sie den Eimer genau auf das Ziel steuern.\n\n'...
                'Achten Sie bitte auf Ihre Augenbewegungen und vermeiden Sie es während eines Versuchs zu blinzeln. Wenn der Punkt in der Mitte am Ende eines Versuchs weiß ist, dürfen Sie blinzeln.\n\nViel Erfolg!'];

            % No catch header
            self.noCatchHeader = 'Leider nicht gefangen!';

            % No catch
            self.noCatch = 'Sie haben leider zu wenig Konfetti gefangen. Versuchen Sie es noch mal!';

            % Accidental catch header
            self.accidentalCatchHeader = 'Leider gefangen!';

            % Accidental catch
            self.accidentalCatch = 'Sie haben zu viel Konfetti gefangen. Versuchen Sie bitte, das Konfetti zu verfehlen!';
            
            % Practice block fail header
            self.practiceBlockFailHeader = 'Bitte noch mal probieren!';
            
            % Practice block fail
            self.practiceBlockFail = ['Sie haben Ihren Eimer oft neben dem Ziel der Kanone platziert. Versuchen Sie im nächsten '...
                'Durchgang bitte, den Eimer direkt auf das Ziel zu steuern. Das Ziel wird mit der Nadel gezeigt.'];

        end


    end
end