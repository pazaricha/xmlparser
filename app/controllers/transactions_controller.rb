class TransactionsController < ApplicationController
  require 'crack/xml'
  require "net/http"

  # require 'rubygems'
  require 'net/sftp'

  def index
  	@transactions = Transaction.all

    uri = URI.parse("http://pazaricha.com")
    @uri = uri.scheme
  end

  def create
  	xml = '<ashrait>
    <response>
        <command>inquireTransactions</command>
        <dateTime>2011-08-04 14:00</dateTime>
        <requestId>723232323</requestId>
        <tranId>5030</tranId>
        <result>000</result>
        <message>Permitted transaction.</message>
        <userMessage>Permitted transaction.</userMessage>
        <additionalInfo></additionalInfo>
        <version>1000</version>
        <language>Eng</language>
        <inquireTransactions>
            <row>
                <mpiTransactionId>
                    459c35c1-80d1-4fa7-b6ac-60c33987b958
                </mpiTransactionId>
                <uniqueid>
                    837683509-84983498539
                </uniqueid>
                <amount>10000</amount>
                <currency>ILS</currency>
                <authNumber>0123456</authNumber>
                <cardId>1018812649454580</cardId>
                <personalId>200553857</personalId>
                <cardExpiration>1212</cardExpiration>
                <languageCode>EN</languageCode>
                <statusCode>0</statusCode>
                <statusText>SUCCEEDED</statusText>
                <errorCode>00</errorCode>
                <errorText>SUCCESS</errorText>
                <cgGatewayResponseCode>000</cgGatewayResponseCode>
                <cgGatewayResponseText>
                    Permitted transaction.
                </cgGatewayResponseText>
                <cgGatewayResponseXML>
                    <ashrait>
                        <response>
                        	<responseUrl>http://pazaricha.com</responseUrl>
                            <command>doDeal</command>
                            <dateTime>2011-08-04 12:10</dateTime>
                            <requestId></requestId>
                            <tranId>227079</tranId>
                            <result>000</result>
                            <message>Permitted transaction.</message>
                            <userMessage>Permitted transaction.</userMessage>
                            <additionalInfo></additionalInfo>
                            <version>1000</version>
                            <language>Eng</language>
                            <doDeal>
                                <status>000</status>
                                <statusText>Permitted transaction.</statusText>
                                <terminalNumber>0962922</terminalNumber>
                                <cardId>1018812649454580</cardId>
                                <cardBin>458045</cardBin>
                                <cardMask>458045******4580</cardMask>
                                <cardLength>16</cardLength>
                                <cardNo>xxxxxxxxxxxx4580</cardNo>
                                <cardName></cardName>
                                <cardExpiration>0114</cardExpiration>
                                <cardType code="0">Local</cardType>
                                <creditCompany code="11">Isracard</creditCompany>
                                <cardBrand code="1">Mastercard</cardBrand>
                                <cardAcquirer code="1">Isracard</cardAcquirer>
                                <serviceCode>000</serviceCode>
                                <transactionType 
                                    code="02">AuthDebit</transactionType>
                                    <creditType code="1">RegularCredit</creditType>
                                    <currency code="1">ILS</currency>
                                    <transactionCode code="50">Phone</transactionCode>
                                    <total>24000</total>
                                    <balance></balance>
                                    <starTotal>0</starTotal>
                                    <firstPayment></firstPayment>
                                    <periodicalPayment></periodicalPayment>
                                    <numberOfPayments></numberOfPayments>
                                    <clubId></clubId>
                                    <clubCode></clubCode>
                                    <validation code="5">AutoComm</validation>
                                    <commReason code="5">VerifyOnly</commReason>
                                    <idStatus code="1">Valid</idStatus>
                                    <cvvStatus code="1">Valid</cvvStatus>
                                    <authSource code="2">CreditCompany</authSource>
                                    <authNumber>4528125</authNumber>
                                    <fileNumber>13</fileNumber>
                                    <slaveTerminalNumber>001</slaveTerminalNumber>
                                    <slaveTerminalSequence>001</slaveTerminalSequence>
                                    <creditGroup>
                                    </creditGroup>
                                    <pinKeyIn>
                                    </pinKeyIn>
                                    <pfsc>
                                    </pfsc>
                                    <eci>
                                    </eci>
                                    <cavv code=" ">
                                    </cavv>
                                    <user>
                                    </user>
                                    <addonData>
                                    </addonData>
                                    <supplierNumber>5032560</supplierNumber>
                                </doDeal>
                            </response>
                        </ashrait>
                    </cgGatewayResponseXML>
                    <queryErrorText>SUCCESS</queryErrorText>
                    <xRem></xRem>
                </row>
                <totals>
                    <pageNumber>
                    </pageNumber>
                    <pagesAmount>
                    </pagesAmount>
                    <queryResultId>
                    </queryResultId>
                    <total>
                    </total>
                    <totalMatch>
                    </totalMatch>
                </totals>
            </inquireTransactions>
        </response>
    </ashrait>'

  	@parsed_xml = Crack::XML.parse(xml)

  	card_id = @parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["cardId"]
  	personal_id = @parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["personalId"]
  	card_expiration = @parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["cardExpiration"]
  	cgresponse_text = (@parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["cgGatewayResponseText"]).strip
  	amount = @parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["amount"]
  	response_url = @parsed_xml["ashrait"]["response"]["inquireTransactions"]["row"]["cgGatewayResponseXML"]["ashrait"]["response"]["responseUrl"]

  	@transaction = Transaction.new(:card_id => card_id, :personal_id => personal_id, :card_expiration => card_expiration, :cgresponse_text => cgresponse_text, :amount => cgresponse_text, :response_url => response_url )



  	if @transaction.save
      flash[:notice] = "Transaction was successfully created."
      redirect_to '/transactions/index'
    else
      flash[:alert] = "Something went wrong"
      redirect_to '/transactions/index'
    end
  end

  def upload 
    Net::SFTP.start('s133234.gridserver.com', 'bluzgraphics.com', :password => 'p2265a96z31') do |sftp|
      @sftp = sftp # I've got a session object so that seems to work
      
      # upload a file or directory to the remote host
      sftp.upload!("/Users/kensodev/Desktop/2.png", "/nfs/c09/h03/mnt/133234/domains/inbar-paz.com/html/test/2.png")
      # sftp.download!("/domains/inbar-paz.com/html/index.html", "/Users/kensodev/Desktop/index.html")
    end
  end
end
