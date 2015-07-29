module Present::Harvest
  class SendInvoice
    def initialize
      @connection = Connection.create
    end

    def send!(present_invoice)
      generated_invoice = Present::Harvest::GeneratedInvoice.new(present_invoice)
      harvest_invoice_for(generated_invoice, @connection).tap do |harvest_invoice|
        harvest_invoice.subject = generated_invoice.subject
        harvest_invoice.due_at_human_format = "net 30"
        harvest_invoice.line_items = generated_invoice.line_items.map {|h| Harvest::LineItem.new(h) }
        persist_invoice!(harvest_invoice, generated_invoice, @connection)
      end
    end

  private

    def harvest_invoice_for(generated_invoice, conn)
      find_existing_invoice(generated_invoice.harvest_id, conn) || Harvest::Invoice.new(:client_id => generated_invoice.project.client.harvest_id)
    end

    def find_existing_invoice(id, conn)
      return unless id.present?
      conn.invoices.find(id)
    rescue Harvest::NotFound
    end

    def persist_invoice!(harvest_invoice, generated_invoice, conn)
      persisted_harvest_invoice = if harvest_invoice.id?
        conn.invoices.update(harvest_invoice)
      else
        conn.invoices.create(harvest_invoice)
      end
      generated_invoice.you_were_just_submitted_to_harvest(persisted_harvest_invoice.id)
    end
  end
end
