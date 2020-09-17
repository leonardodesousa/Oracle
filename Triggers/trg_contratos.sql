CREATE OR REPLACE TRIGGER trg_contratos
  BEFORE INSERT ON t402cont
  FOR EACH ROW
DECLARE
BEGIN
  IF( :new.nr_ctr IS NULL )
  THEN
    :new.nr_ctr := s_contratos.nextval;
  END IF;
END;


