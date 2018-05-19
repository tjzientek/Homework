Sub Calc()

    For Each ws In Worksheets
        
            Dim column As Integer
            column = 1
            
            Dim stockvolume As Double
            stockvolume = 0
            
            Dim rowcounter As Integer
            rowcounter = 2
            
            ws.Range("I1").Value = "Ticker"
            ws.Range("J1").Value = "Yearly Change"
            ws.Range("K1").Value = "Percent Change"
            ws.Range("L1").Value = "Total Stock Volume"
            
            Dim LastRowNum As Long
            LastRowNum = ws.Cells(Rows.Count, 1).End(xlUp).Row
            
            Dim stockopen As Double
            stockopen = 0
            Dim stockclose As Double
            stockclose = 0
            
            Dim prctincreaseticker As String
            Dim prctincreasevalue As Double
            Dim prctdecreaseticker As String
            Dim prctdecreasevalue As Double
            Dim totalvolumeticker As String
            Dim totalvolumevalue As Double
            
            stockopen = ws.Cells(2, 3).Value
            
            For i = 2 To LastRowNum
                
                If (ws.Cells(i + 1, column).Value <> ws.Cells(i, column).Value) Then
                    
                        stockclose = ws.Cells(i, 6).Value
                        ws.Cells(rowcounter, 9).Value = ws.Cells(i, column).Value
                        ws.Cells(rowcounter, 12).Value = stockvolume
                        ws.Cells(rowcounter, 10).Value = stockclose - stockopen
                        
                        If ((stockclose - stockopen) <> 0 And stockopen <> 0) Then
                            ws.Cells(rowcounter, 11).Value = (stockclose - stockopen) / stockopen
                        Else
                            ws.Cells(rowcounter, 11).Value = 0
                        End If
                        
                        ws.Cells(rowcounter, 11).NumberFormat = "0.00%"
                        
                        If (ws.Cells(rowcounter, 10).Value >= 0) Then
                            ws.Cells(rowcounter, 10).Interior.ColorIndex = 4
                        Else
                            ws.Cells(rowcounter, 10).Interior.ColorIndex = 3
                        End If
                        
                        rowcounter = rowcounter + 1
                    
                        stockvolume = ws.Cells(i + 1, 7).Value
                        stockopen = ws.Cells(i + 1, 3).Value
                
                Else

						stockvolume = stockvolume + ws.Cells(i + 1, 7).Value
                
                End If
            
            Next i
            
            prctincreasevalue = ws.Application.WorksheetFunction.Max(ws.Range(ws.Cells(2, 11), ws.Cells(rowcounter, 11)))
            prctincreaseticker = ws.Cells(ws.Application.WorksheetFunction.Match(prctincreasevalue, ws.Range(ws.Cells(2, 11), ws.Cells(rowcounter, 11)), 0) + 1, 9).Value
            
            prctdecreasevalue = ws.Application.WorksheetFunction.Min(ws.Range(ws.Cells(2, 11), ws.Cells(rowcounter, 11)))
            prctdecreaseticker = ws.Cells(ws.Application.WorksheetFunction.Match(prctdecreasevalue, ws.Range(ws.Cells(2, 11), ws.Cells(rowcounter, 11)), 0) + 1, 9).Value
            
            totalvolumevalue = ws.Application.WorksheetFunction.Max(ws.Range(ws.Cells(2, 12), ws.Cells(rowcounter, 12)))
            totalvolumeticker = ws.Cells(ws.Application.WorksheetFunction.Match(totalvolumevalue, ws.Range(ws.Cells(2, 12), ws.Cells(rowcounter, 12)), 0) + 1, 9).Value
            
            ws.Range("O2").Value = "Greatest % Increase"
            ws.Range("O3").Value = "Greatest % Decrease"
            ws.Range("O4").Value = "Greatest Total Volume"
            ws.Range("P1").Value = "Ticker"
            ws.Range("Q1").Value = "Value"
            
            ws.Range("P2").Value = prctincreaseticker
            ws.Range("Q2").Value = prctincreasevalue
            ws.Range("Q2").NumberFormat = "0.00%"
            ws.Range("P3").Value = prctdecreaseticker
            ws.Range("Q3").Value = prctdecreasevalue
            ws.Range("Q3").NumberFormat = "0.00%"
            ws.Range("P4").Value = totalvolumeticker
            ws.Range("Q4").Value = totalvolumevalue
            ws.Range("Q4").NumberFormat = "#,###,###,###"
            
            ws.Columns("A:Q").AutoFit
            
    Next ws

End Sub