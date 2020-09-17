CREATE OR REPLACE TRIGGER trg_cd_cli
BEFORE INSERT ON t400clie
FOR EACH ROW
BEGIN
  IF(:new.cd_cli is null)
  THEN
    :new.cd_cli := s_cd_cli.nextval;
  END IF;
END;
