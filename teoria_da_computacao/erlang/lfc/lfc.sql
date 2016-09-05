DECLARE

  v_states      varchar2(1000);
  v_events      varchar2(1000);
  v_transitions varchar2(1000);

  FUNCTION states(in_service IN VARCHAR2) return VARCHAR2
  is
    v_states varchar2(1000);
  BEGIN
    SELECT '[' || wm_concat(a) || ']' into v_states
      FROM (SELECT DISTINCT ACTUAL_STATUS a
              FROM LFC_MEM_STS_CFG_FLOW flow,
                   LFC_CFG_ENTITY ent
             WHERE ent.ATT2 = in_service
               AND flow.CFG_ID = ent.ID
            UNION
            SELECT DISTINCT NEXT_STATUS a
              FROM LFC_MEM_STS_CFG_FLOW flow,
                   LFC_CFG_ENTITY ent
             WHERE ent.ATT2 = in_service
               AND flow.CFG_ID = ent.ID);

    RETURN v_states;

  END states;

  FUNCTION events(in_service IN VARCHAR2) return VARCHAR2
  is
    v_events varchar2(1000);
  BEGIN
    SELECT '[' || wm_concat(a) || ']' into v_events
      FROM (SELECT distinct EVENT_ID a
              FROM LFC_MEM_STS_CFG_FLOW flow,
                   LFC_CFG_ENTITY ent
             WHERE ent.ATT2 = in_service
               AND flow.CFG_ID = ent.ID);

    RETURN v_events;
  END events;

  FUNCTION transitions(in_service IN VARCHAR2) return VARCHAR2
  is
    v_transitions varchar2(1000);
  BEGIN
    SELECT '[' ||wm_concat('{'||flow.EVENT_ID || ',' || flow.ACTUAL_STATUS || ',' || flow.NEXT_STATUS||',"' || applic.LOGIC_EXP || '"}') || ']'
      INTO v_transitions
      FROM LFC_MEM_STS_CFG_FLOW flow,
           LFC_CFG_ENTITY ent,
           LFC_MEM_STS_CFG_APPLIC applic
     WHERE ent.ATT2      = in_service
       AND flow.CFG_ID   = ent.ID
       AND applic.CFG_ID = ent.ID
       AND applic.ID     = flow.APPLIC_ID;

    RETURN v_transitions;
  END transitions;

BEGIN

  v_states := states(in_service => 'ZAPUNLIMITED');
  DBMS_OUTPUT.PUT_LINE('v_states=' || v_states);
  v_events := events(in_service => 'ZAPUNLIMITED');
  DBMS_OUTPUT.PUT_LINE('v_events=' || v_events);
  v_transitions := transitions(in_service => 'ZAPUNLIMITED');
  DBMS_OUTPUT.PUT_LINE('v_transitions=' || v_transitions);

END;
