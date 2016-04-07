package edu.ucla.library.libservices.invoicing.webservices.invoices.beans;

public class InvoiceEntry
{
  private String invoiceNumber;
  private int lineNumber;
  private String serviceName;
  private String subtypeName;
  private double quantity;
  private double unitPrice;
  private double totalPrice;
  private String adjustmentType;
  private String adjustmentReason;
  private String note;
  private int lineType;
  private String unitMeasure;

  public InvoiceEntry()
  {
    super();
  }

  public void setInvoiceNumber( String invoiceNumber )
  {
    this.invoiceNumber = invoiceNumber;
  }

  public String getInvoiceNumber()
  {
    return invoiceNumber;
  }

  public void setLineNumber( int lineNumber )
  {
    this.lineNumber = lineNumber;
  }

  public int getLineNumber()
  {
    return lineNumber;
  }

  public void setServiceName( String serviceName )
  {
    this.serviceName = serviceName;
  }

  public String getServiceName()
  {
    return serviceName;
  }

  public void setSubtypeName( String subtypeName )
  {
    this.subtypeName = subtypeName;
  }

  public String getSubtypeName()
  {
    return subtypeName;
  }

  public void setQuantity( double quantity )
  {
    this.quantity = quantity;
  }

  public double getQuantity()
  {
    return quantity;
  }

  public void setUnitPrice( double unitPrice )
  {
    this.unitPrice = unitPrice;
  }

  public double getUnitPrice()
  {
    return unitPrice;
  }

  public void setTotalPrice( double totalPrice )
  {
    this.totalPrice = totalPrice;
  }

  public double getTotalPrice()
  {
    return totalPrice;
  }

  public void setAdjustmentType( String adjustmentType )
  {
    this.adjustmentType = adjustmentType;
  }

  public String getAdjustmentType()
  {
    return adjustmentType;
  }

  public void setAdjustmentReason( String adjustmentReason )
  {
    this.adjustmentReason = adjustmentReason;
  }

  public String getAdjustmentReason()
  {
    return adjustmentReason;
  }

  public void setNote( String note )
  {
    this.note = note;
  }

  public String getNote()
  {
    return note;
  }

  public void setLineType( int lineType )
  {
    this.lineType = lineType;
  }

  public int getLineType()
  {
    return lineType;
  }

  public void setUnitMeasure( String unitMeasure )
  {
    this.unitMeasure = unitMeasure;
  }

  public String getUnitMeasure()
  {
    return unitMeasure;
  }
}
