<%
    import datetime
%>

<style type="text/css">
    .matrix table {
        text-align: center;
    }

/*    div.non-editable table.fields td {
        border: inherit;
    }*/

    .matrix table thead th {
        text-transform: none;
    }

    .matrix table .first_column {
        text-align: left;
    }

    .matrix table .total {
        font-weight: bold;
    }

    .matrix table input {
        width: 2.2em;
        min-width: 2.2em;
    }

    .matrix table tbody td,
    .matrix table th,
    .matrix table tfoot tr.boolean_line td {
        border-style: solid;
        border-color: #bbb;
        margin: 0;
        padding: 0 .2em;
    }
    .matrix table tbody td,
    .matrix table th {
        border-width: 0 0 1px;
    }
    .matrix table tfoot tr.boolean_line td {
        border-width: 1px 0 0;
        font-weight: normal;
    }

    .matrix table tfoot span,
    .matrix table tbody span {
        display: block;
    }



    .matrix table tfoot input {
        width: none;
        }

/*    .matrix table tfoot input,
    {
        float: right;
        width: none;
    }

    .matrix table tbody input {
        text-align: center;
    }*/

    .matrix table .button.increment {
        display: block;
        width: 1.5em;
        text-align: center;
    }

    /*.wrapper.action-buttons {
        display:none;
    }*/
</style>

<div class="matrix">

    %if editable:
        <span id="button_template" class="button increment">
            Button template
        </span>
    %endif

    <%
        lines = value.get('matrix_data', [])
    %>

    <table id="${name}">
        <thead>
            <tr>
                <th class="first_column">Line</th>
                %for date in value['date_range']:
                    <th>${datetime.datetime.strptime(date, '%Y%m%d').strftime('%d/%m')}</th>
                %endfor
                <th class="total">Total</th>
            </tr>
        </thead>
        <tfoot>
            <tr class="total_line">
                <td class="first_column">Total</td>
                %for date in value['date_range']:
                    <td>
                        <span class="column_total_${date}">
                            <%
                                column_values = [line['cells_data'][date] for line in lines if line['type'] == 'float' and date in line['cells_data']]
                            %>
                            %if len(column_values):
                                ${sum(column_values)}
                            %endif
                        </span>
                    </td>
                %endfor
                <td class="total">
                    <span id="grand_total">
                        ${sum([sum([v for (k, v) in line['cells_data'].items()]) for line in lines if line['type'] == 'float'])}
                    </span>
                </td>
            </tr>
            %for line in [l for l in lines if l['type'] == 'boolean']:
                <tr class="boolean_line">
                    <td class="first_column">${line['name']}</td>
                    %for date in value['date_range']:
                        <td class="boolean">
                            <%
                                cell_id = 'cell_%s_%s' % (line['id'], date)
                                cell_value = line['cells_data'].get(date, None)
                            %>
                            %if cell_value is not None:
                                %if editable:
                                    <input type="checkbox" kind="boolean" class="checkbox" id="${cell_id}"
                                        %if cell_value:
                                            checked="checked"
                                        %endif
                                    />
                                %else:
                                    <input type="checkbox" name="${cell_id}" id="${cell_id}" kind="boolean" class="checkbox" readonly="readonly" disabled="disabled" value="${cell_value and '1' or '0'}"
                                        %if cell_value:
                                            checked="checked"
                                        %endif
                                    />
                                %endif
                            %endif
                        </td>
                    %endfor
                    <td class="total"></td>
                </tr>
            %endfor
        </tfoot>
        <tbody>
            %for line in [l for l in lines if l['type'] != 'boolean']:
                <tr>
                    <td class="first_column">${line['name']}</td>
                    %for date in value['date_range']:
                        <td class="float">
                            <%
                                cell_id = 'cell_%s_%s' % (line['id'], date)
                                cell_value = line['cells_data'].get(date, None)
                            %>
                            %if cell_value is not None:
                                %if editable:
                                    <input type="text" kind="float" name="${cell_id}" id="${cell_id}" value="${cell_value}" size="1" class="float"/>
                                %else:
                                    <span kind="float" id="${cell_id}" value="${cell_value}">${cell_value}</span>
                                %endif
                            %endif
                        </td>
                    %endfor
                    <td class="total"><span class="row_total_${line['id']}">${sum([v for (k, v) in line['cells_data'].items()])}</span></td>
                </tr>
            %endfor
        </tbody>
    </table>

</div>