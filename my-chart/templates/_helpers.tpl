
{{- define "mylabels" }}
{{- range $key,$val := .Values.labels }}
    {{ $key }}: {{ $val }}
{{- end }}
{{- end }}
