package com.blogspot.ostas.dbpojo.model;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;

public class PojoFieldPrototype {

    private String name;
    private String columnName;
    private String sqlType;
    private String javaType;
    private String getter;
    private String setter;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getSqlType() {
        return sqlType;
    }

    public void setSqlType(String sqlType) {
        this.sqlType = sqlType;
    }

    public String getJavaType() {
        return javaType;
    }

    public void setJavaType(String javaType) {
        this.javaType = javaType;
    }

    public String getGetter() {
        getter = "get"+StringUtils.capitalize(name);
        return getter;
    }

    public void setGetter(String getter) {
        this.getter = getter;
    }

    public String getSetter() {
        setter = "set"+StringUtils.capitalize(name);
        return setter;
    }

    public void setSetter(String setter) {
        this.setter = setter;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PojoFieldPrototype that = (PojoFieldPrototype) o;

        if (!columnName.equals(that.columnName)) return false;
        if (!javaType.equals(that.javaType)) return false;
        if (!name.equals(that.name)) return false;
        return sqlType.equals(that.sqlType);

    }

    @Override
    public int hashCode() {
        int result = name.hashCode();
        result = 31 * result + columnName.hashCode();
        result = 31 * result + sqlType.hashCode();
        result = 31 * result + javaType.hashCode();
        return result;
    }
    @Override
    public String toString() {
        return ReflectionToStringBuilder.toString(this);
    }
}
