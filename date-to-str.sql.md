# Перевод даты в текстовую нотацию

```
UPDATE `items` SET `ready_text` = CONCAT_WS(" ", "Срок сдачи - ",
  ELT(
    SUBSTR(FROM_UNIXTIME(ready), 6, 2),
    "январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"),
    LEFT(FROM_UNIXTIME(ready), 4)
  );
```