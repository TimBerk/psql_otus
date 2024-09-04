-- Дополнительно для подзапросов создается ограничение уникальности для быстрого нахождения товара
--  с последующим расчетом продаж
ALTER TABLE good_sum_mart ADD CONSTRAINT good_name_unique UNIQUE (good_name);

-- Создание функции для работы с обновлением данных
CREATE OR REPLACE FUNCTION update_good_sum_mart() RETURNS TRIGGER AS $$
DECLARE
    total_sales numeric(16, 2);
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Вычисление общей суммы продаж для новой записи
        total_sales := NEW.sales_qty * (SELECT good_price FROM goods WHERE goods_id = NEW.good_id);

        -- Обновление или вставка записи в good_sum_mart
        INSERT INTO good_sum_mart (good_name, sum_sale)
        VALUES ((SELECT good_name FROM goods WHERE goods_id = NEW.good_id), total_sales)
        ON CONFLICT (good_name)
        DO UPDATE SET sum_sale = good_sum_mart.sum_sale + EXCLUDED.sum_sale;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Вычисление разницы в сумме продаж для обновленной записи
        total_sales := (NEW.sales_qty - OLD.sales_qty) * (SELECT good_price FROM goods WHERE goods_id = NEW.good_id);

        -- Обновление записи в good_sum_mart
        UPDATE good_sum_mart
        SET sum_sale = sum_sale + total_sales
        WHERE good_name = (SELECT good_name FROM goods WHERE goods_id = NEW.good_id);

    ELSIF TG_OP = 'DELETE' THEN
        -- Вычисление общей суммы продаж для удаленной записи
        total_sales := OLD.sales_qty * (SELECT good_price FROM goods WHERE goods_id = OLD.good_id);

        -- Обновление записи в good_sum_mart
        UPDATE good_sum_mart
        SET sum_sale = sum_sale - total_sales
        WHERE good_name = (SELECT good_name FROM goods WHERE goods_id = OLD.good_id);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Добавление триггера
CREATE OR REPLACE TRIGGER calculate_report
AFTER INSERT OR UPDATE or DELETE
ON sales
FOR EACH ROW
EXECUTE PROCEDURE update_good_sum_mart();