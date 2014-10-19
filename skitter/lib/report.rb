	def create_report(services)

		File.open("status.txt","w") do |file|
			file.puts("==============================================================")
			file.puts("==============================================================")
			file.puts("Armo el archivo:")
			file.puts("==============================================================")
			file.puts("Informe del estado de los servicios:")
			services.each do |service|
				file.puts("===========================")
				file.puts("Nombre: #{service.name}")
				file.puts("Estado: #{service.status}")
				if service.message != ""
					file.puts("Mensaje: #{service.message}")
				end
				if service.status != "ok"
					file.puts("Controles efectuados con errores: #{service.errors_names.uniq.join("-")} ")
				end
				file.puts("Controles efectuados correctamente: #{service.working_names.uniq.join("-")} ")
				
			end

			file.puts("==============================================================")
		end

	end

	def create_report_full(services)

		File.open("status_full.txt","w") do |file|
			file.puts("==============================================================")
			file.puts("==============================================================")
			file.puts("Armo el archivo:")
			file.puts("==============================================================")
			file.puts("Informe del estado de los servicios:")
			services.each do |service|
				file.puts("===========================")
				file.puts("Nombre: #{service.name}")
				file.puts("Estado: #{service.status}")
				if service.message != ""
					file.puts("Mensaje: #{service.message}")
				end
				if service.status != "ok"
					file.puts("Controles efectuados con errores: #{service.errors_names.uniq.join("-")} ")
					service.errors.each do |errcheq|
						if errcheq.troubleshooting != nil
							file.puts("#{errcheq.name}: #{errcheq.message} Se realizo el troubleshooting: #{errcheq.troubleshooting} => cuyo resultado fue: #{errcheq.troubleshooting_result}")
						else 
							file.puts("#{errcheq.name}: #{errcheq.message}")
						end
					end
				end
				file.puts("Controles efectuados correctamente: #{service.working_names.uniq.join("-")} ")
				service.working.each do |workcheq|
					file.puts("#{workcheq.name}: #{workcheq.message}")
				end
	
				if service.evidence.length > 0
					file.puts("Evidencia:")
					service.evidence.each do |ev|
						file.puts(ev)
					end
				end

			end

			file.puts("==============================================================")
		end

	end
	
	def create_error_full(services)

		File.open("status_error_full.txt","w") do |file|
			file.puts("==============================================================")
			file.puts("==============================================================")
			file.puts("Armo el archivo:")
			file.puts("==============================================================")
			file.puts("Informe del estado de los servicios:")
			services.each do |service|
				if service.status != "ok"
					file.puts("===========================")
					file.puts("Nombre: #{service.name}")
					file.puts("Estado: #{service.status}")
					if service.message != ""
						file.puts("Mensaje: #{service.message}")
					end
					file.puts("Controles efectuados con errores: #{service.errors_names.uniq.join("-")} ")
					service.errors.each do |errcheq|
						if errcheq.troubleshooting != nil
							file.puts("#{errcheq.name}: #{errcheq.message} Se realizo el troubleshooting: #{errcheq.troubleshooting} => cuyo resultado fue: #{errcheq.troubleshooting_result}")
						else 
							file.puts("#{errcheq.name}: #{errcheq.message}")
						end
					end
					file.puts("Controles efectuados correctamente: #{service.working_names.uniq.join("-")} ")
					service.working.each do |workcheq|
						file.puts("#{workcheq.name}: #{workcheq.message}")
					end
				end
				if service.evidence.length > 0
					file.puts("Evidencia:")
					service.evidence.each do |ev|
						file.puts(ev)
					end
				end

			end

			file.puts("==============================================================")
		end

	end
