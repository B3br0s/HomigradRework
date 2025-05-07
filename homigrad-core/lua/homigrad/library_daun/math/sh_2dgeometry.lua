function math.boxinbox(x1,y1,w1,h1,x2,y2,w2,h2)
    return
        ((x2 + w2 >= x1 or x2 >= x1) and x2 <= x1 + w1) and
        ((y2 + h2 >= y1 or y2 >= y1) and y2 <= y1 + h1)
end

function math.pointinbox(x1,y1,x2,y2,w2,h2)
    return
        (x1 > x2 and x1 < x2 + w2) and 
        (y1 > y2 and y1 < y2 + h2)
end