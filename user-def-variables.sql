-- ������ � ����������������� �����������

-- ������� � �������
SET NAMES UTF8;
CREATE TABLE `regions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `company` varchar(64) NOT NULL DEFAULT '',
  `region` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_search` (`company`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `regions` (`id`,`is_active`,`company`,`region`) VALUES 
(1,1,'NEC Neva','St Petersburg'), (2,1,'Kemwater/ZAO Polyche','St Petersburg'),
(3,1,'Kia Motor-Baltika','Kaliningrad'), (4,1,'Klaipeda Food','Kaliningrad'), (5,1,'LG Semicon Europe','Moscow'),
(6,1,'Lucent Technologies','St Petersburg'), (7,1,'Mana-Russia','St Petersburg'), (8,1,'Pobeda-Knauf','St Petersburg'),
(9,1,'Amerpap','Moscow'), (10,1,'International Bank o','Moscow'), (11,1,'Searle Pharma','Moscow'), (12,1,'Motorola','St Petersburg'),
(13,1,'NCR','St Petersburg'), (14,1,'Neste','St Petersburg'), (15,1,'Neste Penoplast','St Petersburg'), (16,1,'PepsiCo','Samara'),
(17,1,'Sanitek','Moscow'), (18,1,'Marbiopharm','Mari El'), (19,1,'KPK','St Petersburg'), (20,1,'Knauf Tigi','Moscow');


-- ������ 1
-- GROUP ����������� ����� SELECT
SET @counter := 0;
SELECT `company`, @counter := @counter + 1 AS `counter` 
FROM `regions` WHERE `is_active` = 1 GROUP BY `region` ORDER BY `counter`;
-- counter: 1, 3, 5, 16, 18

-- ������ 2
-- GROUP ������� �� ����� �����, "�������" ������
SET @counter := 0;
SELECT `company`, @counter AS `counter`
FROM `regions` WHERE `is_active` = 1 GROUP BY `region`, LEAST(0, @counter := @counter + 1) ORDER BY `counter`;
-- counter: 1, 3, 5, 16, 18

-- ������ 3
-- ������� ������������ �� ���������� ����������
SET @counter := 0;
SELECT `company`, @counter AS `counter`
FROM (SELECT `company` FROM `regions` WHERE `is_active` = 1 GROUP BY `region`) AS `dummy_alias` WHERE LEAST(0, @counter := @counter + 1) = 0 ORDER BY `counter`;
-- counter: 1, 2, 3, 4, 5

-- ������ 4
-- �� �� �����, �� � �������� ������ ������� - ���� � UNION. ������������ "OR FALSE" � �� "AND FALSE" ��� ���
-- � �����-���� ������ ������� SQL ��������� "(CONDITION) AND FALSE" ����� ������ ����������� ��� ���������� "CONDITION".
-- ��� ����� ���� ������������ standalone-��������.
-- � ������ �������, "CONDITION" ����� ���� "UNKNOWN", � ������, ������, ������ ��������� "CONDITION"
SELECT 
`company`, `counter` FROM (SELECT NULL AS `company`, NULL AS `counter`) AS `dummy_alias` WHERE LEAST(0, @counter := 0) <> 0 OR FALSE
UNION ALL
SELECT `company`, @counter := @counter + 1 AS `counter`
FROM (SELECT `company` FROM `regions` WHERE `is_active` = 1 GROUP BY `region`) AS `dummy_alias2`;
-- counter: 1, 2, 3, 4, 5

