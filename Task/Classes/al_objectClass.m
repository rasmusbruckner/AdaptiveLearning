classdef al_objectClass
     %AL_OBJECTCLASS This class definition file specifies the 
     % properties of an object that combines multiple objects
     % in one object

    % Properties of the object class
    % ------------------------------

    properties
       gParam % general parameters
       cannon % cannon-object instance
       circle % circle-object instance
       keys % keys-object instance
       triggers % triggers-object instance
       timingParam % timing-object instance
       colors % colors-object instance
       strings % strings-object instance
       subject % subject-object instance
       trialflow % trialflow-object instance
       display % display-object instance
       instructionText % instruction-text-object-instance
       unitTest % unit-test case
    end
end

