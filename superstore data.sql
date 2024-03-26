SELECT 
    o.[customer_id],
    c.[customer_name],
    c.[city],
    c.[country],
    c.[segment],
    c.[region],
    o.[product_id],
    p.[product_name],
    p.[category],
    p.[sub_category],
    LEFT(o.[order_date],7) AS order_date,
    o.[sales],
    pr.price,
    CONCAT(pr.[discount], '%') AS discount, 
    ((1 - pr.discount / 100) * pr.price) AS final_price,
    cs.cost,
    SUM((((1 - pr.discount / 100) * pr.price) - cs.cost) * o.sales) AS profit,
    SUM(o.sales * ((1 - pr.discount / 100) * pr.price)) AS revenue,
    o.year,
    DATENAME(MONTH, o.order_date) AS month
FROM 
    [order] AS o
INNER JOIN 
    customer AS c ON o.customer_id = c.customer_id
INNER JOIN 
    product AS p ON o.product_id = p.product_id
INNER JOIN 
    pricelist AS pr ON o.product_id = pr.product_id
INNER JOIN 
    cost AS cs ON o.product_id = cs.product_id
GROUP BY 
    o.[customer_id],
    c.[customer_name],
    c.[city],
    LEFT(o.[order_date],7),
    c.[country],
    c.[segment],
    c.[region],
    o.[product_id],
    p.[product_name],
    p.[category],
    p.[sub_category],
    o.[order_priority],
    o.[sales],
    pr.price,
    pr.[discount],
    cs.cost,
    o.year,
    DATENAME(MONTH, o.order_date)
ORDER BY 
    SUM(o.sales * ((1 - pr.discount / 100) * pr.price)) DESC;

